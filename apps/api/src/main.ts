/**
 * Refly API 服务器主入口文件
 *
 * 这是 Refly 后端 API 服务器的启动文件，负责：
 * 1. 初始化 NestJS 应用
 * 2. 配置中间件和安全设置
 * 3. 设置错误监控和日志
 * 4. 启动 HTTP 和 WebSocket 服务器
 */

import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'node:path';
import cookieParser from 'cookie-parser';
import helmet from 'helmet';

// 错误监控和性能分析
import * as Sentry from '@sentry/node';
import { nodeProfilingIntegration } from '@sentry/profiling-node';
import { Logger } from 'nestjs-pino';

// 应用模块和配置
import { AppModule } from './modules/app.module';
import { ConfigService } from '@nestjs/config';

// 自定义工具和中间件
import tracer from './tracer'; // OpenTelemetry 追踪器
import { setTraceID } from './utils/middleware/set-trace-id'; // 设置请求追踪ID的中间件
import { GlobalExceptionFilter } from './utils/filters/global-exception.filter'; // 全局异常过滤器
import { CustomWsAdapter } from './utils/adapters/ws-adapter'; // 自定义 WebSocket 适配器

/**
 * 初始化 Sentry 错误监控
 *
 * Sentry 用于收集应用运行时错误和性能数据
 * - dsn: Sentry 数据源名称（从环境变量读取）
 * - integrations: 集成性能分析
 * - environment: 运行环境（开发/生产）
 * - tracesSampleRate: 事务采样率（1.0 = 100%）
 * - profilesSampleRate: 性能分析采样率（1.0 = 100%）
 */
Sentry.init({
  dsn: process.env.SENTRY_DSN,
  integrations: [nodeProfilingIntegration()],
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0, // 捕获 100% 的事务用于性能分析
  profilesSampleRate: 1.0, // 捕获 100% 的性能分析数据
});

/**
 * 应用启动函数
 *
 * 这是 NestJS 应用的入口点，负责：
 * 1. 创建应用实例
 * 2. 配置各种中间件和服务
 * 3. 启动服务器监听端口
 */
async function bootstrap() {
  // 创建 NestJS 应用实例
  // - rawBody: true 保留原始请求体（用于 Stripe webhook 验证等）
  // - bufferLogs: false 不缓冲日志，立即输出
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    rawBody: true,
    bufferLogs: false,
  });

  // 配置结构化日志记录器
  app.useLogger(app.get(Logger));

  // 获取配置服务实例
  const configService = app.get(ConfigService);

  // 全局未捕获异常处理
  // 当发生未捕获的异常时，记录到 Sentry
  process.on('uncaughtException', (err) => {
    Sentry.captureException(err);
  });

  // 全局未处理的 Promise 拒绝处理
  // 当 Promise 被拒绝但未处理时，记录到 Sentry
  process.on('unhandledRejection', (err) => {
    Sentry.captureException(err);
  });

  // 配置请求体解析器
  // - JSON 解析器：限制 10MB
  // - URL 编码解析器：限制 10MB，支持嵌套对象
  app.useBodyParser('json', { limit: '10mb' });
  app.useBodyParser('urlencoded', { limit: '10mb', extended: true });

  // 配置静态文件服务
  // - public 目录：静态资源文件（如图片、CSS、JS）
  // - views 目录：模板视图文件
  app.useStaticAssets(join(__dirname, '..', 'public'));
  app.setBaseViewsDir(join(__dirname, '..', 'views'));

  // 信任代理头（当应用部署在反向代理后时使用）
  app.set('trust proxy', true);

  // 应用中间件（按顺序执行）

  // 1. 设置请求追踪ID - 为每个请求生成唯一ID用于日志追踪
  app.use(setTraceID);

  // 2. 安全头设置 - 防止常见Web攻击（XSS、点击劫持等）
  app.use(helmet());

  // 3. 跨域资源共享（CORS）配置
  // - origin: 允许的源（从配置读取，支持多个用逗号分隔）
  // - credentials: 允许发送认证信息（cookies、授权头等）
  app.enableCors({
    origin: configService.get('origin').split(','),
    credentials: true,
  });

  // 4. Cookie 解析器 - 解析请求中的 cookies
  app.use(cookieParser());

  // 5. WebSocket 适配器 - 配置 WebSocket 服务器
  // 使用自定义适配器支持实时协作功能
  app.useWebSocketAdapter(new CustomWsAdapter(app, configService.get<number>('wsPort')));

  // 6. 全局异常过滤器 - 统一处理所有未捕获的异常
  app.useGlobalFilters(new GlobalExceptionFilter(configService));

  // 启动 OpenTelemetry 追踪器
  // 用于分布式追踪和性能监控
  tracer.start();

  // 启动 HTTP 服务器，监听配置的端口
  // 端口号从环境变量或配置文件读取
  await app.listen(configService.get('port'));

  // 服务器启动后，日志会输出监听的端口和地址
}

/**
 * 启动应用
 *
 * 调用 bootstrap 函数启动服务器
 * 如果启动失败，错误会被 Sentry 捕获并记录
 */
bootstrap();

/**
 * Canvas页面组件 - Refly的核心画布编辑页面
 *
 * 功能概述：
 * 1. 根据URL参数显示具体的画布编辑器或首页
 * 2. 管理侧边栏的展开/收起状态
 * 3. 提供画布编辑器的入口界面
 *
 * 路由路径：/canvas/:canvasId
 * 特殊路径：/canvas/empty 显示首页（无具体画布）
 *
 * @component CanvasPage
 */

import { useParams } from 'react-router-dom';
import { Canvas } from '@refly-packages/ai-workspace-common/components/canvas';
import { Button } from 'antd';
import { useSiderStoreShallow } from '@refly/stores';
import { SiderPopover } from '@refly-packages/ai-workspace-common/components/sider/popover';
import { AiOutlineMenuUnfold } from 'react-icons/ai';
import { FrontPage } from '@refly-packages/ai-workspace-common/components/canvas/front-page';

/**
 * Canvas页面主组件
 *
 * 逻辑说明：
 * 1. 从URL参数获取canvasId
 * 2. 根据canvasId的值决定渲染内容：
 *    - 有效的canvasId且不为'empty'：渲染Canvas编辑器
 *    - 空值或'empty'：渲染首页（FrontPage）
 * 3. 管理侧边栏的展开/收起状态
 */
const CanvasPage = () => {
  // 从路由参数中获取canvasId，默认为空字符串
  // 路由格式：/canvas/:canvasId
  const { canvasId = '' } = useParams();

  // 使用Zustand store管理侧边栏状态
  // useSiderStoreShallow使用浅层选择器优化性能
  const { collapse, setCollapse } = useSiderStoreShallow((state) => ({
    collapse: state.collapse, // 侧边栏是否收起
    setCollapse: state.setCollapse, // 设置侧边栏状态的函数
  }));

  /**
   * 条件渲染逻辑：
   * 1. 当canvasId存在且不为'empty'时，渲染Canvas编辑器
   * 2. 否则渲染首页（FrontPage）
   *
   * 设计目的：
   * - /canvas/:canvasId：编辑特定画布
   * - /canvas/empty 或 /canvas/：显示首页，用户可以创建新画布
   */
  return canvasId && canvasId !== 'empty' ? (
    // 情况1：渲染Canvas编辑器
    // Canvas组件是Refly的核心画布编辑器，包含：
    // - 画布编辑区域
    // - 工具栏
    // - 节点管理
    // - 实时协作等功能
    <Canvas canvasId={canvasId} />
  ) : (
    // 情况2：渲染首页（FrontPage）
    // 当没有指定具体画布时，显示首页让用户选择或创建画布
    <div className="flex h-full w-full flex-col">
      {/* 顶部工具栏区域 */}
      {/* 绝对定位，确保在页面顶部显示 */}
      <div className="absolute top-0 left-0 h-16 items-center justify-between px-4 py-2 z-10">
        {/* 
          侧边栏收起时显示展开按钮
          条件：collapse为true（侧边栏已收起）
        */}
        {collapse && (
          // SiderPopover：侧边栏弹出容器，提供更好的用户体验
          <SiderPopover>
            {/* 
              展开侧边栏按钮
              类型：text（无边框按钮）
              图标：AiOutlineMenuUnfold（菜单展开图标）
              点击事件：切换侧边栏状态
            */}
            <Button
              type="text"
              icon={<AiOutlineMenuUnfold size={16} className="text-gray-500 dark:text-gray-400" />}
              onClick={() => {
                // 切换侧边栏的展开/收起状态
                setCollapse(!collapse);
              }}
            />
          </SiderPopover>
        )}
      </div>

      {/* 
        首页内容区域
        FrontPage组件包含：
        - 欢迎界面
        - 最近使用的画布列表
        - 创建新画布的入口
        - 模板选择
        - 项目导航等
        projectId={null}：表示不关联特定项目
      */}
      <FrontPage projectId={null} />
    </div>
  );
};

export default CanvasPage;

/*
  Warnings:

  - You are about to drop the column `pilot_session_id` on the `action_results` table. All the data in the column will be lost.
  - You are about to drop the column `pilot_step_id` on the `action_results` table. All the data in the column will be lost.
  - You are about to drop the column `project_id` on the `canvases` table. All the data in the column will be lost.
  - You are about to drop the column `project_id` on the `documents` table. All the data in the column will be lost.
  - You are about to drop the column `project_id` on the `resources` table. All the data in the column will be lost.
  - You are about to drop the `pilot_sessions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `pilot_steps` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `projects` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `references` table. If the table is not empty, all the data it contains will be lost.

*/
-- AlterEnum
ALTER TYPE "ActionStatus" ADD VALUE 'init';

-- DropForeignKey
ALTER TABLE "canvas_templates" DROP CONSTRAINT "canvas_templates_category_id_fkey";

-- DropForeignKey
ALTER TABLE "canvases" DROP CONSTRAINT "canvases_project_id_fkey";

-- DropForeignKey
ALTER TABLE "documents" DROP CONSTRAINT "documents_project_id_fkey";

-- DropForeignKey
ALTER TABLE "resources" DROP CONSTRAINT "resources_project_id_fkey";

-- DropIndex
DROP INDEX "action_results_pilot_step_id_idx";

-- AlterTable
ALTER TABLE "accounts" ALTER COLUMN "scope" SET DEFAULT '[]';

-- AlterTable
ALTER TABLE "action_results" DROP COLUMN "pilot_session_id",
DROP COLUMN "pilot_step_id",
ADD COLUMN     "actual_provider_item_id" TEXT,
ADD COLUMN     "copilot_session_id" TEXT,
ADD COLUMN     "error_type" TEXT,
ADD COLUMN     "is_auto_model_routed" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "parent_result_id" TEXT,
ADD COLUMN     "toolsets" TEXT,
ADD COLUMN     "workflow_execution_id" TEXT,
ADD COLUMN     "workflow_node_execution_id" TEXT;

-- AlterTable
ALTER TABLE "canvas_templates" ADD COLUMN     "app_id" TEXT,
ADD COLUMN     "cover_storage_key" TEXT,
ADD COLUMN     "credit_usage" INTEGER;

-- AlterTable
ALTER TABLE "canvases" DROP COLUMN "project_id",
ADD COLUMN     "used_toolsets" TEXT,
ADD COLUMN     "visibility" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "workflow" TEXT;

-- AlterTable
ALTER TABLE "checkout_sessions" ADD COLUMN     "current_plan" TEXT,
ADD COLUMN     "source" TEXT;

-- AlterTable
ALTER TABLE "code_artifacts" ADD COLUMN     "canvas_id" TEXT;

-- AlterTable
ALTER TABLE "documents" DROP COLUMN "project_id",
ADD COLUMN     "canvas_id" TEXT;

-- AlterTable
ALTER TABLE "provider_items" ADD COLUMN     "credit_billing" TEXT,
ADD COLUMN     "global_item_id" TEXT;

-- AlterTable
ALTER TABLE "providers" ADD COLUMN     "extra_params" TEXT;

-- AlterTable
ALTER TABLE "resources" DROP COLUMN "project_id",
ADD COLUMN     "canvas_id" TEXT;

-- AlterTable
ALTER TABLE "static_files" ADD COLUMN     "original_name" TEXT;

-- AlterTable
ALTER TABLE "subscription_plans" ADD COLUMN     "credit_quota" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "daily_gift_credit_quota" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "token_usages" ADD COLUMN     "cache_read_tokens" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "cache_write_tokens" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "model_label" TEXT NOT NULL DEFAULT '',
ADD COLUMN     "model_routed_data" TEXT,
ADD COLUMN     "original_model_id" TEXT,
ADD COLUMN     "provider_item_id" TEXT;

-- DropTable
DROP TABLE "pilot_sessions";

-- DropTable
DROP TABLE "pilot_steps";

-- DropTable
DROP TABLE "projects";

-- DropTable
DROP TABLE "references";

-- CreateTable
CREATE TABLE "action_messages" (
    "pk" BIGSERIAL NOT NULL,
    "message_id" TEXT NOT NULL,
    "result_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 0,
    "type" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "reasoning_content" TEXT,
    "usage_meta" TEXT,
    "tool_call_meta" TEXT,
    "tool_call_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "action_messages_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "api_call_records" (
    "pk" BIGSERIAL NOT NULL,
    "record_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "api_id" TEXT,
    "canvas_id" TEXT,
    "workflow_execution_id" TEXT,
    "request_url" TEXT,
    "request_method" TEXT,
    "request_headers" TEXT,
    "request_body" TEXT,
    "response_body" TEXT,
    "http_status" INTEGER,
    "response_time" INTEGER,
    "status" TEXT NOT NULL,
    "failure_reason" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed_at" TIMESTAMPTZ(6),

    CONSTRAINT "api_call_records_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "auto_model_routing_results" (
    "pk" BIGSERIAL NOT NULL,
    "routing_result_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "action_result_id" TEXT,
    "action_result_version" INTEGER,
    "scene" TEXT,
    "routing_strategy" TEXT NOT NULL,
    "matched_rule_id" TEXT,
    "matched_rule_name" TEXT,
    "original_item_id" TEXT,
    "original_model_id" TEXT,
    "selected_item_id" TEXT NOT NULL,
    "selected_model_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "auto_model_routing_results_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "auto_model_routing_rules" (
    "pk" BIGSERIAL NOT NULL,
    "rule_id" TEXT NOT NULL,
    "rule_name" TEXT NOT NULL,
    "scene" TEXT NOT NULL,
    "condition" TEXT NOT NULL DEFAULT '{}',
    "target" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "auto_model_routing_rules_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "canvas_template_category_relations" (
    "pk" BIGSERIAL NOT NULL,
    "template_id" TEXT NOT NULL,
    "category_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "canvas_template_category_relations_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "cli_device_sessions" (
    "pk" BIGSERIAL NOT NULL,
    "device_id" TEXT NOT NULL,
    "cli_version" TEXT NOT NULL,
    "host" TEXT NOT NULL,
    "user_code" TEXT,
    "client_ip" TEXT,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "uid" TEXT,
    "access_token" TEXT,
    "refresh_token" TEXT,
    "expires_at" TIMESTAMPTZ(6) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cli_device_sessions_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "composio_connections" (
    "pk" BIGSERIAL NOT NULL,
    "uid" TEXT NOT NULL,
    "integration_id" TEXT NOT NULL,
    "connected_account_id" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'active',
    "metadata" TEXT,
    "expires_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "composio_connections_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "copilot_sessions" (
    "pk" BIGSERIAL NOT NULL,
    "session_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "canvas_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "copilot_sessions_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "credit_debts" (
    "pk" BIGSERIAL NOT NULL,
    "debt_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "balance" INTEGER NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "source" TEXT NOT NULL DEFAULT 'usage_overdraft',
    "description" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "credit_debts_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "credit_pack_plans" (
    "pk" BIGSERIAL NOT NULL,
    "pack_id" TEXT NOT NULL,
    "lookup_key" TEXT NOT NULL,
    "credit_quota" INTEGER NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "credit_pack_plans_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "credit_recharges" (
    "pk" BIGSERIAL NOT NULL,
    "recharge_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "balance" INTEGER NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "source" TEXT NOT NULL DEFAULT 'purchase',
    "description" TEXT,
    "app_id" TEXT,
    "extra_data" TEXT,
    "expires_at" TIMESTAMPTZ(6) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "credit_recharges_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "credit_usages" (
    "pk" BIGSERIAL NOT NULL,
    "usage_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "due_amount" INTEGER NOT NULL DEFAULT 0,
    "provider_item_id" TEXT,
    "model_name" TEXT,
    "usage_type" TEXT NOT NULL DEFAULT 'model_call',
    "action_result_id" TEXT,
    "version" INTEGER,
    "description" TEXT,
    "tool_call_id" TEXT,
    "tool_call_meta" TEXT,
    "app_id" TEXT,
    "extra_data" TEXT,
    "model_usage_details" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "credit_usages_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "drive_file_parse_caches" (
    "pk" BIGSERIAL NOT NULL,
    "file_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "content_storage_key" TEXT NOT NULL,
    "content_type" TEXT NOT NULL,
    "parser" TEXT NOT NULL,
    "num_pages" INTEGER,
    "word_count" INTEGER,
    "parse_status" TEXT NOT NULL,
    "parse_error" TEXT,
    "metadata" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "drive_file_parse_caches_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "drive_files" (
    "pk" BIGSERIAL NOT NULL,
    "file_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "canvas_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "size" BIGINT NOT NULL DEFAULT 0,
    "source" TEXT NOT NULL DEFAULT 'manual',
    "scope" TEXT NOT NULL DEFAULT 'present',
    "storage_key" TEXT,
    "summary" TEXT,
    "variable_id" TEXT,
    "result_id" TEXT,
    "result_version" INTEGER,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "drive_files_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "form_definitions" (
    "pk" BIGSERIAL NOT NULL,
    "form_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "schema" TEXT NOT NULL,
    "ui_schema" TEXT,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "form_definitions_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "form_submissions" (
    "pk" BIGSERIAL NOT NULL,
    "form_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "answers" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "form_submissions_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "invitation_codes" (
    "pk" BIGSERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "inviter_uid" TEXT NOT NULL,
    "invitee_uid" TEXT,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "invitation_codes_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "lambda_jobs" (
    "pk" BIGSERIAL NOT NULL,
    "job_id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "name" TEXT,
    "mime_type" TEXT,
    "storage_key" TEXT,
    "storage_type" TEXT NOT NULL DEFAULT 'temporary',
    "file_id" TEXT,
    "result_id" TEXT,
    "result_version" INTEGER,
    "error" TEXT,
    "duration_ms" INTEGER,
    "metadata" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "lambda_jobs_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "promotion_activities" (
    "pk" BIGSERIAL NOT NULL,
    "activity_id" TEXT NOT NULL,
    "activity_name" TEXT NOT NULL,
    "activity_text" TEXT NOT NULL,
    "image_url" TEXT NOT NULL,
    "landing_page_url" TEXT NOT NULL,
    "landing_page_url_zh" TEXT,
    "landing_page_url_en" TEXT,
    "positions" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "status" TEXT NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "promotion_activities_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "prompt_suggestions" (
    "pk" BIGSERIAL NOT NULL,
    "prompt" TEXT NOT NULL,
    "metadata" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "prompt_suggestions_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "skill_execution_workflows" (
    "pk" BIGSERIAL NOT NULL,
    "execution_workflow_id" TEXT NOT NULL,
    "execution_id" TEXT NOT NULL,
    "skill_workflow_id" TEXT NOT NULL,
    "workflow_id" TEXT NOT NULL,
    "execution_level" INTEGER NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "input" TEXT,
    "output" TEXT,
    "error_message" TEXT,
    "retry_count" INTEGER NOT NULL DEFAULT 0,
    "started_at" TIMESTAMPTZ(6),
    "completed_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "skill_execution_workflows_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "skill_executions" (
    "pk" BIGSERIAL NOT NULL,
    "execution_id" TEXT NOT NULL,
    "installation_id" TEXT NOT NULL,
    "skill_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "input" TEXT,
    "output" TEXT,
    "error_message" TEXT,
    "started_at" TIMESTAMPTZ(6),
    "completed_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "skill_executions_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "skill_installations" (
    "pk" BIGSERIAL NOT NULL,
    "installation_id" TEXT NOT NULL,
    "skill_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'downloading',
    "workflow_mapping" TEXT,
    "user_config" TEXT,
    "error_message" TEXT,
    "installed_version" TEXT NOT NULL,
    "has_update" BOOLEAN NOT NULL DEFAULT false,
    "available_version" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "skill_installations_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "skill_packages" (
    "pk" BIGSERIAL NOT NULL,
    "skill_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "description" TEXT,
    "uid" TEXT NOT NULL,
    "icon" TEXT,
    "triggers" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "tags" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "mcp_config" TEXT,
    "input_schema" TEXT,
    "output_schema" TEXT,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "is_public" BOOLEAN NOT NULL DEFAULT false,
    "cover_storage_key" TEXT,
    "download_count" INTEGER NOT NULL DEFAULT 0,
    "share_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "github_pr_number" INTEGER,
    "github_pr_url" TEXT,
    "github_submitted_at" TIMESTAMPTZ(6),

    CONSTRAINT "skill_packages_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "skill_workflow_dependencies" (
    "pk" BIGSERIAL NOT NULL,
    "dependent_workflow_id" TEXT NOT NULL,
    "dependency_workflow_id" TEXT NOT NULL,
    "dependency_type" TEXT NOT NULL DEFAULT 'sequential',
    "condition" TEXT,
    "input_mapping" TEXT,
    "output_selector" TEXT,
    "merge_strategy" TEXT,
    "custom_merge" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "skill_workflow_dependencies_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "skill_workflows" (
    "pk" BIGSERIAL NOT NULL,
    "skill_workflow_id" TEXT NOT NULL,
    "skill_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "canvas_storage_key" TEXT NOT NULL,
    "source_canvas_id" TEXT,
    "input_schema" TEXT,
    "output_schema" TEXT,
    "variables" TEXT,
    "is_entry" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "skill_workflows_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "stripe_coupons" (
    "pk" BIGSERIAL NOT NULL,
    "discount_percent" INTEGER NOT NULL,
    "stripe_coupon_id" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "stripe_coupons_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "tool_call_results" (
    "pk" SERIAL NOT NULL,
    "result_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 0,
    "call_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "toolset_id" TEXT NOT NULL,
    "tool_name" TEXT NOT NULL,
    "step_name" TEXT,
    "input" TEXT NOT NULL,
    "output" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'executing',
    "error" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "tool_call_results_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "tool_methods" (
    "pk" SERIAL NOT NULL,
    "inventory_key" TEXT NOT NULL,
    "version_id" INTEGER NOT NULL DEFAULT 1,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "endpoint" TEXT NOT NULL,
    "http_method" TEXT NOT NULL DEFAULT 'POST',
    "request_schema" TEXT NOT NULL,
    "response_schema" TEXT NOT NULL,
    "adapter_type" TEXT NOT NULL DEFAULT 'http',
    "adapter_config" TEXT,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "tool_methods_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "toolset_inventory" (
    "pk" SERIAL NOT NULL,
    "key" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "domain" TEXT,
    "label_dict" TEXT NOT NULL,
    "description_dict" TEXT NOT NULL,
    "api_key" TEXT,
    "type" TEXT NOT NULL DEFAULT 'regular',
    "adapter_type" TEXT NOT NULL DEFAULT 'http',
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "credit_billing" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "toolset_inventory_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "toolsets" (
    "pk" SERIAL NOT NULL,
    "toolset_id" TEXT NOT NULL,
    "is_global" BOOLEAN NOT NULL DEFAULT false,
    "uid" TEXT,
    "name" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "auth_type" TEXT DEFAULT 'config_based',
    "auth_data" TEXT,
    "config" TEXT,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "uninstalled" BOOLEAN NOT NULL DEFAULT false,
    "credit_billing" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "toolsets_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "user_api_keys" (
    "pk" BIGSERIAL NOT NULL,
    "key_id" TEXT NOT NULL,
    "key_hash" TEXT NOT NULL,
    "key_prefix" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "last_used_at" TIMESTAMPTZ(6),
    "expires_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revoked_at" TIMESTAMPTZ(6),

    CONSTRAINT "user_api_keys_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "variable_extraction_history" (
    "pk" BIGSERIAL NOT NULL,
    "session_id" TEXT,
    "canvas_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "trigger_type" TEXT NOT NULL,
    "extraction_mode" TEXT NOT NULL,
    "original_prompt" TEXT NOT NULL,
    "processed_prompt" TEXT,
    "extracted_variables" TEXT NOT NULL,
    "reused_variables" TEXT NOT NULL DEFAULT '[]',
    "extraction_confidence" DECIMAL(3,2),
    "llm_model" TEXT,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "applied_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "variable_extraction_history_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "voucher_invitations" (
    "pk" BIGSERIAL NOT NULL,
    "invitation_id" TEXT NOT NULL,
    "inviter_uid" TEXT NOT NULL,
    "invitee_uid" TEXT,
    "invite_code" TEXT NOT NULL,
    "voucher_id" TEXT NOT NULL,
    "discount_percent" INTEGER NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'unclaimed',
    "claimed_at" TIMESTAMPTZ(6),
    "reward_granted" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "voucher_invitations_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "voucher_popup_logs" (
    "pk" BIGSERIAL NOT NULL,
    "uid" TEXT NOT NULL,
    "template_id" TEXT NOT NULL,
    "popup_date" TEXT NOT NULL,
    "voucher_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "voucher_popup_logs_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "vouchers" (
    "pk" BIGSERIAL NOT NULL,
    "voucher_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "discount_percent" INTEGER NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'unused',
    "source" TEXT NOT NULL,
    "source_id" TEXT,
    "llm_score" INTEGER,
    "expires_at" TIMESTAMPTZ(6) NOT NULL,
    "used_at" TIMESTAMPTZ(6),
    "subscription_id" TEXT,
    "stripe_promo_code_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "vouchers_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "workflow_apps" (
    "pk" BIGSERIAL NOT NULL,
    "app_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "title" TEXT NOT NULL DEFAULT '',
    "description" TEXT,
    "query" TEXT,
    "variables" TEXT,
    "canvas_id" TEXT,
    "storage_key" TEXT,
    "share_id" TEXT,
    "template_share_id" TEXT,
    "cover_storage_key" TEXT,
    "template_content" TEXT,
    "template_generation_status" TEXT NOT NULL DEFAULT 'idle',
    "template_generation_error" TEXT,
    "remix_enabled" BOOLEAN NOT NULL DEFAULT false,
    "publish_to_community" BOOLEAN NOT NULL DEFAULT false,
    "publish_review_status" TEXT NOT NULL DEFAULT 'init',
    "remarks" TEXT,
    "result_node_ids" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "credit_usage" INTEGER,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "workflow_apps_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "workflow_executions" (
    "pk" BIGSERIAL NOT NULL,
    "execution_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "canvas_id" TEXT NOT NULL,
    "source_canvas_id" TEXT NOT NULL DEFAULT '',
    "title" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'init',
    "aborted_by_user" BOOLEAN NOT NULL DEFAULT false,
    "app_id" TEXT,
    "variables" TEXT,
    "total_nodes" INTEGER NOT NULL DEFAULT 0,
    "executed_nodes" INTEGER NOT NULL DEFAULT 0,
    "failed_nodes" INTEGER NOT NULL DEFAULT 0,
    "schedule_id" TEXT,
    "schedule_record_id" TEXT,
    "trigger_type" TEXT NOT NULL DEFAULT 'manual',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "workflow_executions_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "workflow_node_executions" (
    "pk" BIGSERIAL NOT NULL,
    "node_execution_id" TEXT NOT NULL,
    "execution_id" TEXT NOT NULL,
    "canvas_id" TEXT NOT NULL DEFAULT '',
    "node_id" TEXT NOT NULL,
    "node_type" TEXT NOT NULL,
    "node_data" TEXT NOT NULL DEFAULT '{}',
    "entity_id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "original_query" TEXT,
    "processed_query" TEXT,
    "status" TEXT NOT NULL DEFAULT 'waiting',
    "progress" INTEGER NOT NULL DEFAULT 0,
    "connect_to" TEXT NOT NULL DEFAULT '[]',
    "result_history" TEXT,
    "parent_node_ids" TEXT NOT NULL DEFAULT '[]',
    "child_node_ids" TEXT NOT NULL DEFAULT '[]',
    "start_time" TIMESTAMPTZ(6),
    "end_time" TIMESTAMPTZ(6),
    "error_message" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "workflow_node_executions_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "workflow_openapi_configs" (
    "pk" BIGSERIAL NOT NULL,
    "uid" TEXT NOT NULL,
    "canvas_id" TEXT NOT NULL,
    "result_node_ids" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "workflow_openapi_configs_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "workflow_plans" (
    "pk" BIGSERIAL NOT NULL,
    "plan_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 0,
    "uid" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "data" TEXT NOT NULL,
    "patch" TEXT,
    "result_id" TEXT NOT NULL,
    "result_version" INTEGER NOT NULL,
    "copilot_session_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "workflow_plans_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "workflow_schedule_records" (
    "pk" BIGSERIAL NOT NULL,
    "schedule_record_id" TEXT NOT NULL,
    "schedule_id" TEXT NOT NULL,
    "workflow_execution_id" TEXT,
    "uid" TEXT NOT NULL,
    "canvas_id" TEXT NOT NULL,
    "source_canvas_id" TEXT NOT NULL DEFAULT '',
    "workflow_title" TEXT NOT NULL,
    "used_tools" TEXT,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "credit_used" INTEGER NOT NULL DEFAULT 0,
    "priority" INTEGER NOT NULL DEFAULT 5,
    "scheduled_at" TIMESTAMPTZ(6) NOT NULL,
    "triggered_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed_at" TIMESTAMPTZ(6),
    "failure_reason" TEXT,
    "error_details" TEXT,
    "snapshot_storage_key" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "workflow_schedule_records_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "workflow_schedules" (
    "pk" BIGSERIAL NOT NULL,
    "schedule_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "canvas_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_enabled" BOOLEAN NOT NULL DEFAULT false,
    "cron_expression" TEXT NOT NULL,
    "schedule_config" TEXT NOT NULL,
    "timezone" TEXT NOT NULL DEFAULT 'Asia/Shanghai',
    "next_run_at" TIMESTAMPTZ(6),
    "last_run_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "workflow_schedules_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "workflow_webhooks" (
    "pk" BIGSERIAL NOT NULL,
    "webhook_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "canvas_id" TEXT NOT NULL,
    "is_enabled" BOOLEAN NOT NULL DEFAULT false,
    "timeout" INTEGER NOT NULL DEFAULT 30,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "workflow_webhooks_pkey" PRIMARY KEY ("pk")
);

-- CreateIndex
CREATE UNIQUE INDEX "action_messages_message_id_key" ON "action_messages"("message_id");

-- CreateIndex
CREATE INDEX "action_messages_result_id_version_idx" ON "action_messages"("result_id", "version");

-- CreateIndex
CREATE UNIQUE INDEX "api_call_records_record_id_key" ON "api_call_records"("record_id");

-- CreateIndex
CREATE INDEX "api_call_records_api_id_idx" ON "api_call_records"("api_id");

-- CreateIndex
CREATE INDEX "api_call_records_created_at_idx" ON "api_call_records"("created_at" DESC);

-- CreateIndex
CREATE INDEX "api_call_records_uid_idx" ON "api_call_records"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "auto_model_routing_results_routing_result_id_key" ON "auto_model_routing_results"("routing_result_id");

-- CreateIndex
CREATE INDEX "auto_model_routing_results_user_id_created_at_idx" ON "auto_model_routing_results"("user_id", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "auto_model_routing_results_action_result_id_action_result_v_key" ON "auto_model_routing_results"("action_result_id", "action_result_version");

-- CreateIndex
CREATE UNIQUE INDEX "auto_model_routing_rules_rule_id_key" ON "auto_model_routing_rules"("rule_id");

-- CreateIndex
CREATE INDEX "auto_model_routing_rules_scene_enabled_priority_rule_id_idx" ON "auto_model_routing_rules"("scene", "enabled", "priority" DESC, "rule_id");

-- CreateIndex
CREATE INDEX "canvas_template_category_relations_category_id_deleted_at_idx" ON "canvas_template_category_relations"("category_id", "deleted_at");

-- CreateIndex
CREATE INDEX "canvas_template_category_relations_template_id_deleted_at_idx" ON "canvas_template_category_relations"("template_id", "deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "canvas_template_category_relations_template_id_category_id_key" ON "canvas_template_category_relations"("template_id", "category_id");

-- CreateIndex
CREATE UNIQUE INDEX "cli_device_sessions_device_id_key" ON "cli_device_sessions"("device_id");

-- CreateIndex
CREATE INDEX "cli_device_sessions_status_expires_at_idx" ON "cli_device_sessions"("status", "expires_at");

-- CreateIndex
CREATE INDEX "cli_device_sessions_uid_created_at_idx" ON "cli_device_sessions"("uid", "created_at");

-- CreateIndex
CREATE INDEX "composio_connections_status_idx" ON "composio_connections"("status");

-- CreateIndex
CREATE UNIQUE INDEX "composio_connections_uid_integration_id_key" ON "composio_connections"("uid", "integration_id");

-- CreateIndex
CREATE UNIQUE INDEX "copilot_sessions_session_id_key" ON "copilot_sessions"("session_id");

-- CreateIndex
CREATE INDEX "copilot_sessions_uid_canvas_id_idx" ON "copilot_sessions"("uid", "canvas_id");

-- CreateIndex
CREATE UNIQUE INDEX "credit_debts_debt_id_key" ON "credit_debts"("debt_id");

-- CreateIndex
CREATE INDEX "credit_debts_uid_enabled_created_at_idx" ON "credit_debts"("uid", "enabled", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "credit_pack_plans_pack_id_key" ON "credit_pack_plans"("pack_id");

-- CreateIndex
CREATE UNIQUE INDEX "credit_recharges_recharge_id_key" ON "credit_recharges"("recharge_id");

-- CreateIndex
CREATE INDEX "credit_recharges_expires_at_enabled_idx" ON "credit_recharges"("expires_at", "enabled");

-- CreateIndex
CREATE INDEX "credit_recharges_uid_created_at_idx" ON "credit_recharges"("uid", "created_at");

-- CreateIndex
CREATE INDEX "credit_recharges_uid_enabled_created_at_idx" ON "credit_recharges"("uid", "enabled", "created_at");

-- CreateIndex
CREATE INDEX "credit_recharges_uid_enabled_expires_at_idx" ON "credit_recharges"("uid", "enabled", "expires_at");

-- CreateIndex
CREATE INDEX "credit_recharges_uid_source_enabled_idx" ON "credit_recharges"("uid", "source", "enabled");

-- CreateIndex
CREATE UNIQUE INDEX "credit_usages_usage_id_key" ON "credit_usages"("usage_id");

-- CreateIndex
CREATE INDEX "credit_usages_action_result_id_idx" ON "credit_usages"("action_result_id");

-- CreateIndex
CREATE INDEX "credit_usages_provider_item_id_created_at_idx" ON "credit_usages"("provider_item_id", "created_at");

-- CreateIndex
CREATE INDEX "credit_usages_uid_created_at_idx" ON "credit_usages"("uid", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "drive_file_parse_caches_file_id_key" ON "drive_file_parse_caches"("file_id");

-- CreateIndex
CREATE INDEX "drive_file_parse_caches_parse_status_idx" ON "drive_file_parse_caches"("parse_status");

-- CreateIndex
CREATE INDEX "drive_file_parse_caches_uid_created_at_idx" ON "drive_file_parse_caches"("uid", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "drive_files_file_id_key" ON "drive_files"("file_id");

-- CreateIndex
CREATE INDEX "drive_files_canvas_id_deleted_at_updated_at_idx" ON "drive_files"("canvas_id", "deleted_at", "updated_at");

-- CreateIndex
CREATE UNIQUE INDEX "form_definitions_form_id_key" ON "form_definitions"("form_id");

-- CreateIndex
CREATE INDEX "form_definitions_uid_deleted_at_idx" ON "form_definitions"("uid", "deleted_at");

-- CreateIndex
CREATE INDEX "form_submissions_form_id_uid_idx" ON "form_submissions"("form_id", "uid");

-- CreateIndex
CREATE INDEX "form_submissions_uid_created_at_idx" ON "form_submissions"("uid", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "invitation_codes_code_key" ON "invitation_codes"("code");

-- CreateIndex
CREATE UNIQUE INDEX "invitation_codes_invitee_uid_key" ON "invitation_codes"("invitee_uid");

-- CreateIndex
CREATE INDEX "invitation_codes_invitee_uid_idx" ON "invitation_codes"("invitee_uid");

-- CreateIndex
CREATE INDEX "invitation_codes_inviter_uid_idx" ON "invitation_codes"("inviter_uid");

-- CreateIndex
CREATE INDEX "invitation_codes_status_idx" ON "invitation_codes"("status");

-- CreateIndex
CREATE UNIQUE INDEX "invitation_codes_inviter_uid_invitee_uid_key" ON "invitation_codes"("inviter_uid", "invitee_uid");

-- CreateIndex
CREATE UNIQUE INDEX "lambda_jobs_job_id_key" ON "lambda_jobs"("job_id");

-- CreateIndex
CREATE INDEX "lambda_jobs_file_id_idx" ON "lambda_jobs"("file_id");

-- CreateIndex
CREATE INDEX "lambda_jobs_result_id_result_version_idx" ON "lambda_jobs"("result_id", "result_version");

-- CreateIndex
CREATE INDEX "lambda_jobs_status_created_at_idx" ON "lambda_jobs"("status", "created_at");

-- CreateIndex
CREATE INDEX "lambda_jobs_uid_created_at_idx" ON "lambda_jobs"("uid", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "promotion_activities_activity_id_key" ON "promotion_activities"("activity_id");

-- CreateIndex
CREATE INDEX "promotion_activities_created_at_idx" ON "promotion_activities"("created_at");

-- CreateIndex
CREATE INDEX "promotion_activities_status_deleted_at_idx" ON "promotion_activities"("status", "deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "skill_execution_workflows_execution_workflow_id_key" ON "skill_execution_workflows"("execution_workflow_id");

-- CreateIndex
CREATE INDEX "skill_execution_workflows_execution_id_status_idx" ON "skill_execution_workflows"("execution_id", "status");

-- CreateIndex
CREATE INDEX "skill_execution_workflows_execution_level_idx" ON "skill_execution_workflows"("execution_level");

-- CreateIndex
CREATE UNIQUE INDEX "skill_executions_execution_id_key" ON "skill_executions"("execution_id");

-- CreateIndex
CREATE INDEX "skill_executions_installation_id_status_idx" ON "skill_executions"("installation_id", "status");

-- CreateIndex
CREATE INDEX "skill_executions_skill_id_status_idx" ON "skill_executions"("skill_id", "status");

-- CreateIndex
CREATE INDEX "skill_executions_uid_created_at_idx" ON "skill_executions"("uid", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "skill_installations_installation_id_key" ON "skill_installations"("installation_id");

-- CreateIndex
CREATE INDEX "skill_installations_uid_status_deleted_at_idx" ON "skill_installations"("uid", "status", "deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "skill_installations_skill_id_uid_key" ON "skill_installations"("skill_id", "uid");

-- CreateIndex
CREATE UNIQUE INDEX "skill_packages_skill_id_key" ON "skill_packages"("skill_id");

-- CreateIndex
CREATE INDEX "skill_packages_is_public_status_deleted_at_idx" ON "skill_packages"("is_public", "status", "deleted_at");

-- CreateIndex
CREATE INDEX "skill_packages_share_id_idx" ON "skill_packages"("share_id");

-- CreateIndex
CREATE INDEX "skill_packages_uid_status_deleted_at_idx" ON "skill_packages"("uid", "status", "deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "skill_workflow_dependencies_dependent_workflow_id_dependenc_key" ON "skill_workflow_dependencies"("dependent_workflow_id", "dependency_workflow_id");

-- CreateIndex
CREATE UNIQUE INDEX "skill_workflows_skill_workflow_id_key" ON "skill_workflows"("skill_workflow_id");

-- CreateIndex
CREATE INDEX "skill_workflows_skill_id_idx" ON "skill_workflows"("skill_id");

-- CreateIndex
CREATE UNIQUE INDEX "stripe_coupons_discount_percent_key" ON "stripe_coupons"("discount_percent");

-- CreateIndex
CREATE UNIQUE INDEX "stripe_coupons_stripe_coupon_id_key" ON "stripe_coupons"("stripe_coupon_id");

-- CreateIndex
CREATE UNIQUE INDEX "tool_call_results_call_id_key" ON "tool_call_results"("call_id");

-- CreateIndex
CREATE INDEX "tool_call_results_result_id_version_idx" ON "tool_call_results"("result_id", "version");

-- CreateIndex
CREATE INDEX "tool_call_results_tool_name_deleted_at_idx" ON "tool_call_results"("tool_name", "deleted_at");

-- CreateIndex
CREATE INDEX "tool_call_results_toolset_id_deleted_at_idx" ON "tool_call_results"("toolset_id", "deleted_at");

-- CreateIndex
CREATE INDEX "tool_methods_version_id_idx" ON "tool_methods"("version_id");

-- CreateIndex
CREATE UNIQUE INDEX "tool_methods_inventory_key_name_version_id_key" ON "tool_methods"("inventory_key", "name", "version_id");

-- CreateIndex
CREATE UNIQUE INDEX "toolset_inventory_key_key" ON "toolset_inventory"("key");

-- CreateIndex
CREATE INDEX "toolset_inventory_key_idx" ON "toolset_inventory"("key");

-- CreateIndex
CREATE UNIQUE INDEX "toolsets_toolset_id_key" ON "toolsets"("toolset_id");

-- CreateIndex
CREATE INDEX "toolsets_key_enabled_idx" ON "toolsets"("key", "enabled");

-- CreateIndex
CREATE INDEX "toolsets_uid_is_global_deleted_at_idx" ON "toolsets"("uid", "is_global", "deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "user_api_keys_key_id_key" ON "user_api_keys"("key_id");

-- CreateIndex
CREATE INDEX "user_api_keys_key_hash_idx" ON "user_api_keys"("key_hash");

-- CreateIndex
CREATE INDEX "user_api_keys_uid_revoked_at_idx" ON "user_api_keys"("uid", "revoked_at");

-- CreateIndex
CREATE UNIQUE INDEX "variable_extraction_history_session_id_key" ON "variable_extraction_history"("session_id");

-- CreateIndex
CREATE INDEX "variable_extraction_history_canvas_id_uid_created_at_idx" ON "variable_extraction_history"("canvas_id", "uid", "created_at");

-- CreateIndex
CREATE INDEX "variable_extraction_history_extraction_confidence_idx" ON "variable_extraction_history"("extraction_confidence");

-- CreateIndex
CREATE INDEX "variable_extraction_history_trigger_type_extraction_mode_idx" ON "variable_extraction_history"("trigger_type", "extraction_mode");

-- CreateIndex
CREATE UNIQUE INDEX "voucher_invitations_invitation_id_key" ON "voucher_invitations"("invitation_id");

-- CreateIndex
CREATE UNIQUE INDEX "voucher_invitations_invite_code_key" ON "voucher_invitations"("invite_code");

-- CreateIndex
CREATE INDEX "voucher_invitations_invite_code_idx" ON "voucher_invitations"("invite_code");

-- CreateIndex
CREATE INDEX "voucher_invitations_invitee_uid_idx" ON "voucher_invitations"("invitee_uid");

-- CreateIndex
CREATE INDEX "voucher_invitations_inviter_uid_status_idx" ON "voucher_invitations"("inviter_uid", "status");

-- CreateIndex
CREATE INDEX "voucher_invitations_status_claimed_at_idx" ON "voucher_invitations"("status", "claimed_at");

-- CreateIndex
CREATE INDEX "voucher_popup_logs_uid_popup_date_idx" ON "voucher_popup_logs"("uid", "popup_date");

-- CreateIndex
CREATE INDEX "voucher_popup_logs_voucher_id_idx" ON "voucher_popup_logs"("voucher_id");

-- CreateIndex
CREATE UNIQUE INDEX "vouchers_voucher_id_key" ON "vouchers"("voucher_id");

-- CreateIndex
CREATE INDEX "vouchers_status_expires_at_idx" ON "vouchers"("status", "expires_at");

-- CreateIndex
CREATE INDEX "vouchers_uid_status_expires_at_idx" ON "vouchers"("uid", "status", "expires_at");

-- CreateIndex
CREATE UNIQUE INDEX "workflow_apps_app_id_key" ON "workflow_apps"("app_id");

-- CreateIndex
CREATE INDEX "workflow_apps_canvas_id_deleted_at_idx" ON "workflow_apps"("canvas_id", "deleted_at");

-- CreateIndex
CREATE INDEX "workflow_apps_share_id_idx" ON "workflow_apps"("share_id");

-- CreateIndex
CREATE INDEX "workflow_apps_template_share_id_idx" ON "workflow_apps"("template_share_id");

-- CreateIndex
CREATE UNIQUE INDEX "workflow_executions_execution_id_key" ON "workflow_executions"("execution_id");

-- CreateIndex
CREATE INDEX "workflow_executions_schedule_id_created_at_idx" ON "workflow_executions"("schedule_id", "created_at");

-- CreateIndex
CREATE INDEX "workflow_executions_trigger_type_created_at_idx" ON "workflow_executions"("trigger_type", "created_at");

-- CreateIndex
CREATE INDEX "workflow_executions_uid_canvas_id_idx" ON "workflow_executions"("uid", "canvas_id");

-- CreateIndex
CREATE UNIQUE INDEX "workflow_node_executions_node_execution_id_key" ON "workflow_node_executions"("node_execution_id");

-- CreateIndex
CREATE INDEX "workflow_node_executions_execution_id_node_id_idx" ON "workflow_node_executions"("execution_id", "node_id");

-- CreateIndex
CREATE INDEX "workflow_node_executions_execution_id_status_idx" ON "workflow_node_executions"("execution_id", "status");

-- CreateIndex
CREATE INDEX "workflow_openapi_configs_uid_idx" ON "workflow_openapi_configs"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "workflow_openapi_configs_canvas_id_uid_key" ON "workflow_openapi_configs"("canvas_id", "uid");

-- CreateIndex
CREATE INDEX "workflow_plans_copilot_session_id_version_idx" ON "workflow_plans"("copilot_session_id", "version");

-- CreateIndex
CREATE INDEX "workflow_plans_plan_id_version_idx" ON "workflow_plans"("plan_id", "version");

-- CreateIndex
CREATE INDEX "workflow_plans_result_id_result_version_idx" ON "workflow_plans"("result_id", "result_version");

-- CreateIndex
CREATE UNIQUE INDEX "workflow_schedule_records_schedule_record_id_key" ON "workflow_schedule_records"("schedule_record_id");

-- CreateIndex
CREATE INDEX "workflow_schedule_records_schedule_id_scheduled_at_idx" ON "workflow_schedule_records"("schedule_id", "scheduled_at");

-- CreateIndex
CREATE INDEX "workflow_schedule_records_uid_status_completed_at_idx" ON "workflow_schedule_records"("uid", "status", "completed_at" DESC);

-- CreateIndex
CREATE INDEX "workflow_schedule_records_uid_status_scheduled_at_idx" ON "workflow_schedule_records"("uid", "status", "scheduled_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "workflow_schedules_schedule_id_key" ON "workflow_schedules"("schedule_id");

-- CreateIndex
CREATE INDEX "workflow_schedules_is_enabled_deleted_at_next_run_at_idx" ON "workflow_schedules"("is_enabled", "deleted_at", "next_run_at");

-- CreateIndex
CREATE INDEX "workflow_schedules_uid_deleted_at_created_at_idx" ON "workflow_schedules"("uid", "deleted_at", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "workflow_schedules_canvas_id_uid_key" ON "workflow_schedules"("canvas_id", "uid");

-- CreateIndex
CREATE UNIQUE INDEX "workflow_webhooks_webhook_id_key" ON "workflow_webhooks"("webhook_id");

-- CreateIndex
CREATE INDEX "idx_workflow_webhooks_api_id" ON "workflow_webhooks"("webhook_id");

-- CreateIndex
CREATE INDEX "workflow_webhooks_uid_idx" ON "workflow_webhooks"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "workflow_webhooks_canvas_id_uid_key" ON "workflow_webhooks"("canvas_id", "uid");

-- CreateIndex
CREATE INDEX "action_results_copilot_session_id_idx" ON "action_results"("copilot_session_id");

-- CreateIndex
CREATE INDEX "canvases_uid_visibility_updated_at_idx" ON "canvases"("uid", "visibility", "updated_at");

-- CreateIndex
CREATE INDEX "provider_items_global_item_id_idx" ON "provider_items"("global_item_id");

-- CreateIndex
CREATE INDEX "token_usages_original_model_id_created_at_idx" ON "token_usages"("original_model_id", "created_at");

-- AddForeignKey
ALTER TABLE "resources" ADD CONSTRAINT "resources_canvas_id_fkey" FOREIGN KEY ("canvas_id") REFERENCES "canvases"("canvas_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_canvas_id_fkey" FOREIGN KEY ("canvas_id") REFERENCES "canvases"("canvas_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "code_artifacts" ADD CONSTRAINT "code_artifacts_canvas_id_fkey" FOREIGN KEY ("canvas_id") REFERENCES "canvases"("canvas_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "form_submissions" ADD CONSTRAINT "form_submissions_form_id_fkey" FOREIGN KEY ("form_id") REFERENCES "form_definitions"("form_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "skill_execution_workflows" ADD CONSTRAINT "skill_execution_workflows_execution_id_fkey" FOREIGN KEY ("execution_id") REFERENCES "skill_executions"("execution_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "skill_executions" ADD CONSTRAINT "skill_executions_installation_id_fkey" FOREIGN KEY ("installation_id") REFERENCES "skill_installations"("installation_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "skill_installations" ADD CONSTRAINT "skill_installations_skill_id_fkey" FOREIGN KEY ("skill_id") REFERENCES "skill_packages"("skill_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "skill_workflow_dependencies" ADD CONSTRAINT "skill_workflow_dependencies_dependency_workflow_id_fkey" FOREIGN KEY ("dependency_workflow_id") REFERENCES "skill_workflows"("skill_workflow_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "skill_workflow_dependencies" ADD CONSTRAINT "skill_workflow_dependencies_dependent_workflow_id_fkey" FOREIGN KEY ("dependent_workflow_id") REFERENCES "skill_workflows"("skill_workflow_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "skill_workflows" ADD CONSTRAINT "skill_workflows_skill_id_fkey" FOREIGN KEY ("skill_id") REFERENCES "skill_packages"("skill_id") ON DELETE RESTRICT ON UPDATE CASCADE;

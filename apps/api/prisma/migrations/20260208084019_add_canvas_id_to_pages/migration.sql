/*
  Warnings:

  - The values [init] on the enum `ActionStatus` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `actual_provider_item_id` on the `action_results` table. All the data in the column will be lost.
  - You are about to drop the column `copilot_session_id` on the `action_results` table. All the data in the column will be lost.
  - You are about to drop the column `error_type` on the `action_results` table. All the data in the column will be lost.
  - You are about to drop the column `is_auto_model_routed` on the `action_results` table. All the data in the column will be lost.
  - You are about to drop the column `parent_result_id` on the `action_results` table. All the data in the column will be lost.
  - You are about to drop the column `toolsets` on the `action_results` table. All the data in the column will be lost.
  - You are about to drop the column `workflow_execution_id` on the `action_results` table. All the data in the column will be lost.
  - You are about to drop the column `workflow_node_execution_id` on the `action_results` table. All the data in the column will be lost.
  - You are about to drop the column `app_id` on the `canvas_templates` table. All the data in the column will be lost.
  - You are about to drop the column `cover_storage_key` on the `canvas_templates` table. All the data in the column will be lost.
  - You are about to drop the column `credit_usage` on the `canvas_templates` table. All the data in the column will be lost.
  - You are about to drop the column `used_toolsets` on the `canvases` table. All the data in the column will be lost.
  - You are about to drop the column `visibility` on the `canvases` table. All the data in the column will be lost.
  - You are about to drop the column `workflow` on the `canvases` table. All the data in the column will be lost.
  - You are about to drop the column `current_plan` on the `checkout_sessions` table. All the data in the column will be lost.
  - You are about to drop the column `source` on the `checkout_sessions` table. All the data in the column will be lost.
  - You are about to drop the column `canvas_id` on the `code_artifacts` table. All the data in the column will be lost.
  - You are about to drop the column `canvas_id` on the `documents` table. All the data in the column will be lost.
  - You are about to drop the column `credit_billing` on the `provider_items` table. All the data in the column will be lost.
  - You are about to drop the column `global_item_id` on the `provider_items` table. All the data in the column will be lost.
  - You are about to drop the column `extra_params` on the `providers` table. All the data in the column will be lost.
  - You are about to drop the column `canvas_id` on the `resources` table. All the data in the column will be lost.
  - You are about to drop the column `original_name` on the `static_files` table. All the data in the column will be lost.
  - You are about to drop the column `credit_quota` on the `subscription_plans` table. All the data in the column will be lost.
  - You are about to drop the column `daily_gift_credit_quota` on the `subscription_plans` table. All the data in the column will be lost.
  - You are about to drop the column `cache_read_tokens` on the `token_usages` table. All the data in the column will be lost.
  - You are about to drop the column `cache_write_tokens` on the `token_usages` table. All the data in the column will be lost.
  - You are about to drop the column `model_label` on the `token_usages` table. All the data in the column will be lost.
  - You are about to drop the column `model_routed_data` on the `token_usages` table. All the data in the column will be lost.
  - You are about to drop the column `original_model_id` on the `token_usages` table. All the data in the column will be lost.
  - You are about to drop the column `provider_item_id` on the `token_usages` table. All the data in the column will be lost.
  - You are about to drop the `action_messages` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `api_call_records` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `auto_model_routing_results` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `auto_model_routing_rules` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `canvas_template_category_relations` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `cli_device_sessions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `composio_connections` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `copilot_sessions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `credit_debts` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `credit_pack_plans` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `credit_recharges` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `credit_usages` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `drive_file_parse_caches` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `drive_files` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `form_definitions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `form_submissions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `invitation_codes` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `lambda_jobs` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `promotion_activities` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `prompt_suggestions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `skill_execution_workflows` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `skill_executions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `skill_installations` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `skill_packages` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `skill_workflow_dependencies` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `skill_workflows` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `stripe_coupons` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tool_call_results` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tool_methods` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `toolset_inventory` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `toolsets` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `user_api_keys` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `variable_extraction_history` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `voucher_invitations` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `voucher_popup_logs` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `vouchers` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `workflow_apps` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `workflow_executions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `workflow_node_executions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `workflow_openapi_configs` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `workflow_plans` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `workflow_schedule_records` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `workflow_schedules` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `workflow_webhooks` table. If the table is not empty, all the data it contains will be lost.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "ActionStatus_new" AS ENUM ('waiting', 'executing', 'finish', 'failed');
ALTER TABLE "action_results" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "action_results" ALTER COLUMN "status" TYPE "ActionStatus_new" USING ("status"::text::"ActionStatus_new");
ALTER TYPE "ActionStatus" RENAME TO "ActionStatus_old";
ALTER TYPE "ActionStatus_new" RENAME TO "ActionStatus";
DROP TYPE "ActionStatus_old";
ALTER TABLE "action_results" ALTER COLUMN "status" SET DEFAULT 'waiting';
COMMIT;

-- DropForeignKey
ALTER TABLE "code_artifacts" DROP CONSTRAINT "code_artifacts_canvas_id_fkey";

-- DropForeignKey
ALTER TABLE "documents" DROP CONSTRAINT "documents_canvas_id_fkey";

-- DropForeignKey
ALTER TABLE "form_submissions" DROP CONSTRAINT "form_submissions_form_id_fkey";

-- DropForeignKey
ALTER TABLE "resources" DROP CONSTRAINT "resources_canvas_id_fkey";

-- DropForeignKey
ALTER TABLE "skill_execution_workflows" DROP CONSTRAINT "skill_execution_workflows_execution_id_fkey";

-- DropForeignKey
ALTER TABLE "skill_executions" DROP CONSTRAINT "skill_executions_installation_id_fkey";

-- DropForeignKey
ALTER TABLE "skill_installations" DROP CONSTRAINT "skill_installations_skill_id_fkey";

-- DropForeignKey
ALTER TABLE "skill_workflow_dependencies" DROP CONSTRAINT "skill_workflow_dependencies_dependency_workflow_id_fkey";

-- DropForeignKey
ALTER TABLE "skill_workflow_dependencies" DROP CONSTRAINT "skill_workflow_dependencies_dependent_workflow_id_fkey";

-- DropForeignKey
ALTER TABLE "skill_workflows" DROP CONSTRAINT "skill_workflows_skill_id_fkey";

-- DropIndex
DROP INDEX "action_results_copilot_session_id_idx";

-- DropIndex
DROP INDEX "canvases_uid_visibility_updated_at_idx";

-- DropIndex
DROP INDEX "provider_items_global_item_id_idx";

-- DropIndex
DROP INDEX "token_usages_original_model_id_created_at_idx";

-- AlterTable
ALTER TABLE "accounts" ALTER COLUMN "scope" DROP DEFAULT;

-- AlterTable
ALTER TABLE "action_results" DROP COLUMN "actual_provider_item_id",
DROP COLUMN "copilot_session_id",
DROP COLUMN "error_type",
DROP COLUMN "is_auto_model_routed",
DROP COLUMN "parent_result_id",
DROP COLUMN "toolsets",
DROP COLUMN "workflow_execution_id",
DROP COLUMN "workflow_node_execution_id",
ADD COLUMN     "pilot_session_id" TEXT,
ADD COLUMN     "pilot_step_id" TEXT;

-- AlterTable
ALTER TABLE "canvas_templates" DROP COLUMN "app_id",
DROP COLUMN "cover_storage_key",
DROP COLUMN "credit_usage";

-- AlterTable
ALTER TABLE "canvases" DROP COLUMN "used_toolsets",
DROP COLUMN "visibility",
DROP COLUMN "workflow",
ADD COLUMN     "project_id" TEXT;

-- AlterTable
ALTER TABLE "checkout_sessions" DROP COLUMN "current_plan",
DROP COLUMN "source";

-- AlterTable
ALTER TABLE "code_artifacts" DROP COLUMN "canvas_id";

-- AlterTable
ALTER TABLE "documents" DROP COLUMN "canvas_id",
ADD COLUMN     "project_id" TEXT;

-- AlterTable
ALTER TABLE "provider_items" DROP COLUMN "credit_billing",
DROP COLUMN "global_item_id";

-- AlterTable
ALTER TABLE "providers" DROP COLUMN "extra_params";

-- AlterTable
ALTER TABLE "resources" DROP COLUMN "canvas_id",
ADD COLUMN     "project_id" TEXT;

-- AlterTable
ALTER TABLE "static_files" DROP COLUMN "original_name";

-- AlterTable
ALTER TABLE "subscription_plans" DROP COLUMN "credit_quota",
DROP COLUMN "daily_gift_credit_quota";

-- AlterTable
ALTER TABLE "token_usages" DROP COLUMN "cache_read_tokens",
DROP COLUMN "cache_write_tokens",
DROP COLUMN "model_label",
DROP COLUMN "model_routed_data",
DROP COLUMN "original_model_id",
DROP COLUMN "provider_item_id";

-- DropTable
DROP TABLE "action_messages";

-- DropTable
DROP TABLE "api_call_records";

-- DropTable
DROP TABLE "auto_model_routing_results";

-- DropTable
DROP TABLE "auto_model_routing_rules";

-- DropTable
DROP TABLE "canvas_template_category_relations";

-- DropTable
DROP TABLE "cli_device_sessions";

-- DropTable
DROP TABLE "composio_connections";

-- DropTable
DROP TABLE "copilot_sessions";

-- DropTable
DROP TABLE "credit_debts";

-- DropTable
DROP TABLE "credit_pack_plans";

-- DropTable
DROP TABLE "credit_recharges";

-- DropTable
DROP TABLE "credit_usages";

-- DropTable
DROP TABLE "drive_file_parse_caches";

-- DropTable
DROP TABLE "drive_files";

-- DropTable
DROP TABLE "form_definitions";

-- DropTable
DROP TABLE "form_submissions";

-- DropTable
DROP TABLE "invitation_codes";

-- DropTable
DROP TABLE "lambda_jobs";

-- DropTable
DROP TABLE "promotion_activities";

-- DropTable
DROP TABLE "prompt_suggestions";

-- DropTable
DROP TABLE "skill_execution_workflows";

-- DropTable
DROP TABLE "skill_executions";

-- DropTable
DROP TABLE "skill_installations";

-- DropTable
DROP TABLE "skill_packages";

-- DropTable
DROP TABLE "skill_workflow_dependencies";

-- DropTable
DROP TABLE "skill_workflows";

-- DropTable
DROP TABLE "stripe_coupons";

-- DropTable
DROP TABLE "tool_call_results";

-- DropTable
DROP TABLE "tool_methods";

-- DropTable
DROP TABLE "toolset_inventory";

-- DropTable
DROP TABLE "toolsets";

-- DropTable
DROP TABLE "user_api_keys";

-- DropTable
DROP TABLE "variable_extraction_history";

-- DropTable
DROP TABLE "voucher_invitations";

-- DropTable
DROP TABLE "voucher_popup_logs";

-- DropTable
DROP TABLE "vouchers";

-- DropTable
DROP TABLE "workflow_apps";

-- DropTable
DROP TABLE "workflow_executions";

-- DropTable
DROP TABLE "workflow_node_executions";

-- DropTable
DROP TABLE "workflow_openapi_configs";

-- DropTable
DROP TABLE "workflow_plans";

-- DropTable
DROP TABLE "workflow_schedule_records";

-- DropTable
DROP TABLE "workflow_schedules";

-- DropTable
DROP TABLE "workflow_webhooks";

-- CreateTable
CREATE TABLE "pilot_sessions" (
    "pk" BIGSERIAL NOT NULL,
    "session_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "current_epoch" INTEGER NOT NULL DEFAULT 0,
    "max_epoch" INTEGER NOT NULL DEFAULT 2,
    "title" TEXT NOT NULL,
    "input" TEXT NOT NULL,
    "model_name" TEXT,
    "target_type" TEXT,
    "target_id" TEXT,
    "provider_item_id" TEXT,
    "status" TEXT NOT NULL DEFAULT 'init',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pilot_sessions_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "pilot_steps" (
    "pk" BIGSERIAL NOT NULL,
    "step_id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "epoch" INTEGER NOT NULL,
    "entity_id" TEXT,
    "entity_type" TEXT,
    "status" TEXT NOT NULL DEFAULT 'init',
    "raw_output" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pilot_steps_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "projects" (
    "pk" BIGSERIAL NOT NULL,
    "project_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "description" TEXT,
    "cover_storage_key" TEXT,
    "custom_instructions" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ,

    CONSTRAINT "projects_pkey" PRIMARY KEY ("pk")
);

-- CreateTable
CREATE TABLE "references" (
    "pk" BIGSERIAL NOT NULL,
    "reference_id" TEXT NOT NULL,
    "source_type" TEXT NOT NULL,
    "source_id" TEXT NOT NULL,
    "target_type" TEXT NOT NULL,
    "target_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ,

    CONSTRAINT "references_pkey" PRIMARY KEY ("pk")
);

-- CreateIndex
CREATE UNIQUE INDEX "pilot_sessions_session_id_key" ON "pilot_sessions"("session_id");

-- CreateIndex
CREATE INDEX "pilot_sessions_uid_created_at_idx" ON "pilot_sessions"("uid", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "pilot_steps_step_id_key" ON "pilot_steps"("step_id");

-- CreateIndex
CREATE INDEX "pilot_steps_session_id_created_at_idx" ON "pilot_steps"("session_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "projects_project_id_key" ON "projects"("project_id");

-- CreateIndex
CREATE INDEX "projects_uid_deleted_at_updated_at_idx" ON "projects"("uid", "deleted_at", "updated_at");

-- CreateIndex
CREATE UNIQUE INDEX "references_reference_id_key" ON "references"("reference_id");

-- CreateIndex
CREATE INDEX "references_source_type_source_id_idx" ON "references"("source_type", "source_id");

-- CreateIndex
CREATE INDEX "references_target_type_target_id_idx" ON "references"("target_type", "target_id");

-- CreateIndex
CREATE UNIQUE INDEX "references_source_type_source_id_target_type_target_id_key" ON "references"("source_type", "source_id", "target_type", "target_id");

-- CreateIndex
CREATE INDEX "action_results_pilot_step_id_idx" ON "action_results"("pilot_step_id");

-- AddForeignKey
ALTER TABLE "canvases" ADD CONSTRAINT "canvases_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("project_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "canvas_templates" ADD CONSTRAINT "canvas_templates_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "canvas_template_categories"("category_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "resources" ADD CONSTRAINT "resources_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("project_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("project_id") ON DELETE SET NULL ON UPDATE CASCADE;

# Refly i18n (Internationalization) Scripts Analysis

## Overview
The `/refly/packages/i18n/src/en-US` directory contains the English (US) internationalization files for the Refly AI platform. These scripts provide comprehensive localization support for the entire application, enabling multilingual user interfaces.

## Directory Structure
```
refly/packages/i18n/src/
├── en-US/                    # English (US) translations
│   ├── index.ts             # Main export file
│   ├── ui.ts               # UI translations (largest file)
│   ├── skill.ts            # Skill-related translations
│   └── skill-log.ts        # Skill execution log translations
└── zh-Hans/                 # Simplified Chinese translations
```

## File Breakdown

### 1. **index.ts** - Main Export File
- **Purpose**: Central export point for all English translations
- **Exports**: 
  - `enUSUi`: UI translations (from `ui.ts`)
  - `enUSSkill`: Skill translations (from `skill.ts`)
  - `enUSSkillLog`: Skill log translations (from `skill-log.ts`)

### 2. **ui.ts** - UI Translations (Main File)
- **Size**: ~2,500+ translation keys
- **Structure**: Organized by feature/module:
  - **Common UI Elements**: Buttons, forms, dialogs, notifications
  - **Feature Modules**: Canvas, knowledge base, resources, documents, settings
  - **Workflow Components**: Agent configuration, skill responses, templates
  - **Subscription & Pricing**: Plan details, credit management
  - **Integration**: API, webhook, MCP server configurations

**Key Sections**:
- `common`: Reusable UI components (buttons, modals, notifications)
- `canvas`: Canvas/workflow interface translations
- `knowledgeBase`: Knowledge management features
- `settings`: User settings and configurations
- `subscription`: Pricing plans and credit management
- `integration`: API, webhook, and external integrations

### 3. **skill.ts** - Skill-Specific Translations
- **Purpose**: Translations for AI skills and agents
- **Structure**: Organized by skill type:
  - `agent`: General AI agent translations
  - `commonQnA`: Question-answering skill
  - `customPrompt`: Custom prompt-based skills
  - `codeArtifacts`: Code generation skills
  - `generateDoc`: Document writing skills
  - `webSearch`: Web search capabilities
  - `librarySearch`: Knowledge base search
  - `imageGeneration`: Image generation features
  - `generateMedia`: Multimedia generation (images, videos, audio)

**Each skill includes**:
- `name`: Display name
- `description`: Skill description
- `placeholder`: Input placeholder text
- `steps`: Step-by-step execution translations

### 4. **skill-log.ts** - Skill Execution Logs
- **Purpose**: Translations for skill execution logs and progress messages
- **Structure**: Organized by execution phase:
  - Query analysis and processing
  - Web/library search operations
  - Content generation (documents, code, media)
  - Image/media generation progress tracking
  - Error handling and status messages

## Code Logic & Architecture

### 1. **Modular Design**
- **Separation of Concerns**: UI, skills, and logs are separated for maintainability
- **Feature-Based Organization**: Translations grouped by feature modules
- **Reusable Components**: Common UI elements extracted for consistency

### 2. **Template String Support**
- Uses `{{variable}}` syntax for dynamic content
- Supports pluralization and conditional formatting
- Example: `'Selected {{count}} items'`

### 3. **Hierarchical Structure**
- Deeply nested objects for logical grouping
- Consistent naming conventions
- Type-safe exports through TypeScript

### 4. **Multi-Language Support**
- Package exports support multiple locales (`en-US`, `zh-Hans`)
- Each locale has identical structure for consistency
- Easy to add new languages by following the pattern

## Usage Patterns

### 1. **Import Pattern**
```typescript
import { enUSUi, enUSSkill, enUSSkillLog } from '@refly/i18n/en-US'
```

### 2. **Template Usage**
```typescript
// In React components
t('common.save') // Returns "Save"
t('canvas.nodeTypes.document') // Returns "Document"
t('skillResponse.executing') // Returns "Skill is executing, please wait..."
```

### 3. **Dynamic Variables**
```typescript
t('common.selectedItems', { count: 5 }) // Returns "Selected 5 items"
t('skill.log.webSearchCompleted', { 
  totalResults: 10, 
  duration: 250 
}) // Returns "Total of 10 results, completed in 250ms"
```

## Purpose & Benefits

### 1. **Internationalization**
- Enables multi-language support for global users
- Consistent terminology across the application
- Easy localization updates without code changes

### 2. **Developer Experience**
- Type-safe translations with TypeScript
- Organized structure for easy navigation
- Clear separation between UI and business logic

### 3. **Maintenance**
- Centralized translation management

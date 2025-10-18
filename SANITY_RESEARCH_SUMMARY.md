# Sanity.io Studio Configuration Research Summary

## Research Overview

This document summarizes research on how Sanity.io allows users to configure pages in their Studio and how this was adapted for Flutter CMS.

---

## How Sanity.io Configures Studio Pages

### 1. Central Configuration (`sanity.config.ts`)

Sanity uses a single configuration file with the `defineConfig()` function:

```typescript
import {defineConfig} from 'sanity'
import {structureTool} from 'sanity/structure'
import {schemaTypes} from './schemas'

export default defineConfig({
  projectId: '<projectId>',
  dataset: 'production',
  plugins: [structureTool()],
  schema: {
    types: schemaTypes,
  },
})
```

**Key Properties:**
- `projectId` / `dataset` - Backend connection
- `plugins` - Array of plugins (e.g., structureTool)
- `schema` - Document type definitions
- `title` / `subtitle` - Studio branding
- `icon` - Studio icon

### 2. Schema Types (Document Definitions)

Schemas define content structure and auto-generate editing interfaces:

```javascript
{
  name: 'post',
  title: 'Blog Post',
  type: 'document',
  fields: [
    {name: 'title', type: 'string', title: 'Title'},
    {name: 'slug', type: 'slug', options: {source: 'title'}},
    {name: 'publishedAt', type: 'datetime', title: 'Published'},
  ]
}
```

### 3. Structure Builder API

Customizes navigation and document organization:

```javascript
export const structure = (S) =>
  S.list()
    .title('Content')
    .items([
      // Singleton
      S.listItem()
        .title('Settings')
        .child(
          S.document()
            .schemaType('settings')
            .documentId('settings')
        ),
      S.divider(),
      // Collection
      S.documentTypeListItem('post').title('Blog Posts'),
    ])
```

**Pane Types:**
- **List**: Static collection of items
- **Document List**: Dynamic list that updates real-time
- **Document**: Single document editor
- **Custom Component**: React-based custom views

### 4. Document Views

Multiple views for the same document (form, preview, etc.):

```javascript
S.document()
  .views([
    S.view.form(),
    S.view.component(PreviewComponent).title('Preview')
  ])
```

### 5. Singleton Documents

Single-instance documents (Settings, Homepage):

```javascript
S.document()
  .schemaType('settings')
  .documentId('settings') // Predetermined ID
```

### 6. Filtered Lists

GROQ-based filtering:

```javascript
S.documentList()
  .filter('_type == "post" && published == true')
```

### 7. Workspaces

Multiple workspaces in one Studio:

```typescript
defineConfig([
  {
    name: 'production',
    basePath: '/production',
    dataset: 'production',
    // ...
  },
  {
    name: 'staging',
    basePath: '/staging',
    dataset: 'staging',
    // ...
  },
])
```

---

## Flutter CMS Implementation

### Architectural Mapping

| Sanity.io | Flutter CMS | File |
|-----------|-------------|------|
| `defineConfig()` | `CmsStudioConfig` | cms_config.dart |
| `defineType()` | `CmsDocumentType` | cms_config.dart |
| Structure Builder `S` | `CmsStructureBuilder` | cms_structure.dart |
| Desk Tool UI | `CmsStudio` widget | cms_studio.dart |
| Document Form | `CmsDocumentEditor` | document_editor.dart |
| Document List | `CmsDocumentListView` | document_list.dart |

### Implementation Highlights

#### 1. Studio Configuration (No Helper Functions)

```dart
final config = CmsStudioConfig(
  title: 'My CMS',
  documentTypes: [
    CmsDocumentType(
      name: 'post',
      title: 'Blog Posts',
      fields: [
        CmsTextFieldConfig(name: 'title', title: 'Title'),
      ],
    ),
  ],
);
```

#### 2. Structure Builder API

```dart
structure: (S) {
  return S.list(
    title: 'Content',
    items: [
      S.listItem(
        id: 'settings',
        title: 'Settings',
        child: S.document(
          schemaType: 'settings',
          documentId: 'settings',
        ),
      ),
      S.divider(),
      S.listItem(
        id: 'posts',
        title: 'Posts',
        child: S.documentList(
          schemaType: 'post',
          title: 'Blog Posts',
        ),
      ),
    ],
  );
}
```

#### 3. Singleton Documents

```dart
CmsDocumentType(
  name: 'settings',
  title: 'Settings',
  isSingleton: true,
  singletonId: 'global-settings',
  fields: [...],
)
```

#### 4. Multiple Views

```dart
S.document(
  schemaType: 'page',
  documentId: 'homepage',
  views: [
    S.formView(),
    S.componentView(
      id: 'preview',
      title: 'Preview',
      builder: (context, doc) => PreviewWidget(doc),
    ),
  ],
)
```

#### 5. Filtered Lists

```dart
S.documentList(
  schemaType: 'post',
  title: 'Published Posts',
  filter: 'published == true',
)
```

---

## Key Differences

### Sanity.io (JavaScript/TypeScript)
- Uses helper functions (`defineConfig`, `defineType`)
- GROQ query language for filters
- React components for custom views
- Real-time backend integration
- Pigeon/Vega for complex data viz

### Flutter CMS (Dart/Flutter)
- Uses classes directly (`CmsStudioConfig`, `CmsDocumentType`)
- String-based filters (to be implemented)
- Flutter widgets for custom views
- Backend-agnostic (ready for any backend)
- All 16 field types with shadcn_ui components

---

## Features Implemented

### ✅ Core Features
- [x] Studio configuration object
- [x] Document type definitions
- [x] Structure Builder API with chainable methods
- [x] Sidebar navigation
- [x] Document lists (browsable collections)
- [x] Document editors (dynamic forms)
- [x] Singleton documents
- [x] Collection documents
- [x] Custom structures with grouping
- [x] Visual dividers
- [x] Multiple views (form + custom)
- [x] Search functionality
- [x] Empty states
- [x] All 16 field type support

### 🔄 To Be Implemented
- [ ] Data persistence (backend integration)
- [ ] GROQ-like query filters (actual execution)
- [ ] Real-time updates
- [ ] Document versioning
- [ ] Publish workflows
- [ ] User permissions
- [ ] Multiple workspaces
- [ ] Plugin system
- [ ] Document actions (duplicate, delete, archive)

---

## Example Configuration

See **[example_studio_config.dart](lib/studio/example_studio_config.dart)** for a complete working example.

### Quick Example

```dart
// Configuration
final config = CmsStudioConfig(
  title: 'Blog CMS',
  documentTypes: [
    // Singleton
    CmsDocumentType(
      name: 'settings',
      title: 'Settings',
      isSingleton: true,
      singletonId: 'settings',
      fields: const [
        CmsStringFieldConfig(name: 'siteName', title: 'Site Name'),
      ],
    ),
    // Collection
    CmsDocumentType(
      name: 'post',
      title: 'Posts',
      fields: const [
        CmsTextFieldConfig(name: 'title', title: 'Title'),
        CmsSlugFieldConfig(
          name: 'slug',
          title: 'Slug',
          option: CmsSlugOption(source: 'title', maxLength: 96),
        ),
      ],
    ),
  ],
  structure: (S) => S.list(
    title: 'Content',
    items: [
      S.listItem(
        id: 'settings',
        title: 'Settings',
        child: S.document(schemaType: 'settings', documentId: 'settings'),
      ),
      S.divider(),
      S.listItem(
        id: 'posts',
        title: 'Posts',
        child: S.documentList(schemaType: 'post', title: 'All Posts'),
      ),
    ],
  ),
);

// Usage
void main() {
  runApp(MaterialApp(home: CmsStudio(config: config)));
}
```

---

## Architecture Benefits

### 1. Declarative Configuration
Like Sanity, the entire studio is configured declaratively, making it easy to understand and modify.

### 2. Separation of Concerns
- Configuration (what)
- Structure (how it's organized)
- UI (how it's rendered)

### 3. Flexibility
- Custom structures per use case
- Mix singletons and collections
- Add custom views
- Organize with dividers and groups

### 4. Type Safety
Flutter's strong typing ensures configuration errors are caught at compile-time.

### 5. Extensibility
Easy to add:
- New field types
- Custom views
- Plugins
- Tools

---

## Resources

### Sanity.io Documentation
- [Configuration](https://www.sanity.io/docs/studio/configuration)
- [Structure Tool](https://www.sanity.io/docs/studio/structure-tool)
- [Structure Builder API](https://www.sanity.io/docs/studio/structure-builder-reference)
- [Singleton Documents](https://www.sanity.io/guides/singleton-document)
- [Custom Views](https://www.sanity.io/docs/studio/create-custom-document-views-with-structure-builder)

### Flutter CMS Documentation
- [STUDIO_CONFIGURATION.md](STUDIO_CONFIGURATION.md) - Complete implementation guide
- [COMPONENT_DEVELOPMENT.md](COMPONENT_DEVELOPMENT.md) - UI component guide
- [INPUT_COMPONENTS_SUMMARY.md](INPUT_COMPONENTS_SUMMARY.md) - All input components

---

**Research Date**: 2025-10-05
**Status**: ✅ Research Complete & System Implemented
**Next**: Connect to backend for data persistence

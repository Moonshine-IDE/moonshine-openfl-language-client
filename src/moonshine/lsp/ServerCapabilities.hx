/*
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License

	No warranty of merchantability or fitness of any kind.
	Use this software at your own risk.
 */

package moonshine.lsp;

/**
	Implementation of `ServerCapabilities` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.

	@see https://microsoft.github.io/language-server-protocol/specification#initialize
**/
typedef ServerCapabilities = {
	?textDocumentSync:Any /* TextDocumentSyncOptions | TextDocumentSyncKind */,
	?completionProvider:Any /* CompletionOptions */,
	?hoverProvider:Any /*Bool | HoverOptions */,
	?signatureHelpProvider:Any /* SignatureHelpOptions */,
	?declarationProvider:Any /* Bool | DeclarationOptions | DeclarationRegistrationOptions */,
	?definitionProvider:Any /* Bool | DefinitionOptions */,
	?typeDefinitionProvider:Any /* Bool | TypeDefinitionOptions | TypeDefinitionRegistrationOptions */,
	?implementationProvider:Any /* Bool | ImplementationOptions | ImplementationRegistrationOptions */,
	?referencesProvider:Any /* Bool | ReferenceOptions */,
	?documentHighlightProvider:Any /* Bool | DocumentHighlightOptions */,
	?documentSymbolProvider:Any /* Bool | DocumentSymbolOptions */,
	?codeActionProvider:Any /* Bool | CodeActionOptions */,
	?codeLensProvider:Any /* CodeLensOptions */,
	?documentLinkProvider:Any /* DocumentLinkOptions */,
	?colorProvider:Any /* Bool | DocumentColorOptions | DocumentColorRegistrationOptions */,
	?documentFormattingProvider:Any /* Bool | DocumentFormattingOptions */,
	?documentRangeFormattingProvider:Any /* Bool | DocumentRangeFormattingOptions */,
	?documentOnTypeFormattingProvider:Any /* DocumentOnTypeFormattingOptions */,
	?renameProvider:Any /* Bool | RenameOptions */,
	?foldingRangeProvider:Any /* Bool | FoldingRangeOptions | FoldingRangeRegistrationOptions */,
	?executeCommandProvider:Any /* ExecuteCommandOptions */,
	?selectionRangeProvider:Any /* Bool | SelectionRangeOptions | SelectionRangeRegistrationOptions */,
	?linkedEditingRangeProvider:Any /* Bool | LinkedEditingRangeOptions | LinkedEditingRangeRegistrationOptions */,
	?callHierarchyProvider:Any /* Bool | CallHierarchyOptions | CallHierarchyRegistrationOptions */,
	?semanticTokensProvider:Any /* SemanticTokensOptions | SemanticTokensRegistrationOptions */,
	?monikerProvider:Any /* Bool | MonikerOptions | MonikerRegistrationOptions */,
	?workspaceSymbolProvider:Any /* Bool | WorkspaceSymbolOptions */,
	?workspace:{
		?workspaceFolders:Any /* WorkspaceFoldersServerCapabilities */,
		?fileOperations:{
			?didCreate:Any /* FileOperationRegistrationOptions */,
			?willCreate:Any /* FileOperationRegistrationOptions */,
			?didRename:Any /* FileOperationRegistrationOptions */,
			?willRename:Any /* FileOperationRegistrationOptions */,
			?didDelete:Any /* FileOperationRegistrationOptions */,
			?willDelete:Any /* FileOperationRegistrationOptions */,
		},
		?experimental:Any,
	},
}

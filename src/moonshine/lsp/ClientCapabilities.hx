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

import moonshine.lsp.CompletionItemKind;
import moonshine.lsp.CodeActionKind;
import moonshine.lsp.PrepareSupportDefaultBehavior;
import moonshine.lsp.SymbolKind;
import moonshine.lsp.WorkspaceFolder;
import moonshine.lsp.WorkDoneProgressParams;

/**
	Implementation of `ClientCapabilities` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.

	@see https://microsoft.github.io/language-server-protocol/specification#clientCapabilities
**/
typedef ClientCapabilities = {
	?workspace:{
		?applyEdit:Bool,
		?workspaceEdit:{
			?documentChanges:Bool,
			?resourceOperations:Array<ResourceOperationKind>,
			?failureHandling:FailureHandlingKind,
			?normalizesLineEndings:Bool,
			?changeAnnotationSupport:{
				?groupsOnLabel:Bool,
			},
		},
		?didChangeConfiguration:{
			?dynamicRegistration:Bool,
		},
		?didChangeWatchedFiles:{
			?dynamicRegistration:Bool,
		},
		?symbol:{
			?dynamicRegistration:Bool,
			?symbolKind:{
				?valueSet:Array<SymbolKind>,
			},
			?tagSupport:{
				valueSet:Array<SymbolTag>,
			}
		},
		?executeCommand:{
			?dynamicRegistration:Bool,
		},
		?workspaceFolders:Bool,
		?configuration:Bool,
		?semanticTokens:{
			?refreshSupport:Bool,
		},
		?codeLens:{
			?refreshSupport:Bool,
		},
		?fileOperations:{
			?dynamicRegistration:Bool,
			?didCreate:Bool,
			?willCreate:Bool,
			?didRename:Bool,
			?willRename:Bool,
			?didDelete:Bool,
			?willDelete:Bool,
		},
	},
	?textDocument:{
		?synchronization:{
			?dynamicRegistration:Bool,
			?willSave:Bool,
			?willSaveWaitUntil:Bool,
			?didSave:Bool,
		},
		?completion:{
			?dynamicRegistration:Bool,
			?completionItem:{
				?snippetSupport:Bool,
				?commitCharactersSupport:Bool,
				?documentationFormat:Array<MarkupKind>,
				?deprecatedSupport:Bool,
				?preselectSupport:Bool,
				?tagSupport:{
					valueSet:Array<CompletionItemTag>,
				},
				?insertReplaceSupport:Bool,
				?resolveSupport:{
					properties:Array<String>
				},
				?insertTextModeSupport:{
					valueSet:Array<InsertTextMode>,
				},
				?labelDetailsSupport:Bool,
			},
			?completionItemKind:{
				?valueSet:Array<CompletionItemKind>,
			},
			?contextSupport:Bool,
			?insertTextMode:InsertTextMode,
		},
		?hover:{
			?dynamicRegistration:Bool,
			?contentFormat:Array<MarkupKind>,
		},
		?signatureHelp:{
			?dynamicRegistration:Bool,
			?signatureInformation:{
				?documentationFormat:Array<MarkupKind>,
				?parameterInformation:{
					?labelOffsetSupport:Bool,
				},
				?activeParameterSupport:Bool,
			},
			?contextSupport:Bool,
		},
		?declaration:{
			?dynamicRegistration:Bool,
			?linkSupport:Bool,
		},
		?definition:{
			?dynamicRegistration:Bool,
			?linkSupport:Bool,
		},
		?typeDefinition:{
			?dynamicRegistration:Bool,
			?linkSupport:Bool,
		},
		?implementation:{
			?dynamicRegistration:Bool,
			?linkSupport:Bool,
		},
		?references:{
			?dynamicRegistration:Bool,
		},
		?documentHighlight:{
			?dynamicRegistration:Bool,
		},
		?documentSymbol:{
			?dynamicRegistration:Bool,
			?symbolKind:{
				valueSet:Array<SymbolKind>,
			},
			?hierarchicalDocumentSymbolSupport:Bool,
			?tagSupport:{
				valueSet:Array<SymbolTag>,
			},
			?labelSupport:Bool,
		},
		?codeAction:{
			?dynamicRegistration:Bool,
			?codeActionLiteralSupport:{
				codeActionKind:{
					valueSet:Array<CodeActionKind>,
				},
			},
			?isPreferredSupport:Bool,
			?disabledSupport:Bool,
			?dataSupport:Bool,
			?resolveSupport:{
				properties:Array<String>
			},
		},
		?codeLens:{
			?dynamicRegistration:Bool,
		},
		?documentLink:{
			?dynamicRegistration:Bool,
			?tooltipSupport:Bool,
		},
		?colorProvider:{
			?dynamicRegistration:Bool,
		},
		?formatting:{
			?dynamicRegistration:Bool,
		},
		?rangeFormatting:{
			?dynamicRegistration:Bool,
		},
		?onTypeFormatting:{
			?dynamicRegistration:Bool,
		},
		?rename:{
			?dynamicRegistration:Bool,
			?prepareSupport:Bool,
			?prepareSupportDefaultBehavior:PrepareSupportDefaultBehavior,
			?honorsChangeAnnotations:Bool,
		},
		?publishDiagnostics:{
			?relatedInformation:Bool,
			?tagSupport:{
				valueSet:Array<DiagnosticTag>,
			},
			?versionSupport:Bool,
			?codeDescriptionSupport:Bool,
			?dataSupport:Bool,
		},
		?foldingRange:{
			?dynamicRegistration:Bool,
			?rangeLimit:UInt,
			?lineFoldingOnly:Bool,
		},
		?selectionRange:{
			?dynamicRegistration:Bool,
		},
		?linkedEditingRange:{
			?dynamicRegistration:Bool,
		},
		?callHierarchy:{
			?dynamicRegistration:Bool,
		},
		?semanticTokens:{
			?dynamicRegistration:Bool,
			requests:{
				?range:Any /* Bool | {} */,
				?full:Any /* Bool | {?delta: Bool} */,
			},
			tokenTypes:Array<String>,
			tokenModifiers:Array<String>,
			formats:Array<TokenFormat>,
			?overlappingTokenSupport:Bool,
			?multilineTokenSupport:Bool,
		},
		?moniker:{
			?dynamicRegistration:Bool,
		},
	},
	?window:{
		?workDoneProgress:Bool,
		?showMessage:{
			?messageActionItem:{
				?additionalPropertiesSupport:Bool,
			}
		},
		?showDocument:{
			support:Bool,
		},
	},
	?general:{
		?staleRequestSupport:{
			cancel:Bool,
			retryOnContentModified:Array<String>
		},
		?regularExpressions:{
			engine:String,
			?version:String
		},
		?markdown:{
			parser:String,
			?version:String
		},
	},
	?experimental:Any,
}

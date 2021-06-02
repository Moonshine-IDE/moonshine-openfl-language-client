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
	Implementation of `CompletionItemKind` enumeration from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_completion
	@see https://microsoft.github.io/language-server-protocol/specification#completionItem_resolve
**/
@:enum
abstract CompletionItemKind(Int) from Int to Int {
	var Text = 1;
	var Method = 2;
	var Function = 3;
	var Constructor = 4;
	var Field = 5;
	var Variable = 6;
	var Class = 7;
	var Interface = 8;
	var Module = 9;
	var Property = 10;
	var Unit = 11;
	var Value = 12;
	var Enum = 13;
	var Keyword = 14;
	var Snippet = 15;
	var Color = 16;
	var File = 17;
	var Reference = 18;
	var Folder = 19;
	var EnumMember = 20;
	var Constant = 21;
	var Struct = 22;
	var Event = 23;
	var Operator = 24;
	var TypeParameter = 25;
}

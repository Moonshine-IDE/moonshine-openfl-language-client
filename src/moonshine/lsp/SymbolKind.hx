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
	Implementation of `SymbolKind` enum from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_documentSymbol
	@see https://microsoft.github.io/language-server-protocol/specification#workspace_symbol
**/
#if haxe4 enum #else @:enum #end abstract SymbolKind(Int) from Int to Int {

	var File = 1;
	var Module = 2;
	var Namespace = 3;
	var Package = 4;
	var Class = 5;
	var Method = 6;
	var Property = 7;
	var Field = 8;
	var Constructor = 9;
	var Enum = 10;
	var Interface = 11;
	var Function = 12;
	var Variable = 13;
	var Constant = 14;
	var String = 15;
	var Number = 16;
	var Boolean = 17;
	var Array = 18;
	var Object = 19;
	var Key = 20;
	var Null = 21;
	var EnumMember = 22;
	var Struct = 23;
	var Event = 24;
	var Operator = 25;
	var TypeParameter = 26;
}

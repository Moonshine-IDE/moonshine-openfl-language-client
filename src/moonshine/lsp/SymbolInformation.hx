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
	Implementation of `SymbolInformation` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_documentSymbol
	@see https://microsoft.github.io/language-server-protocol/specification#workspace_symbol
**/
@:structInit
class SymbolInformation {
	/**
		The name of this symbol.
	**/
	public var name:String;

	/**
		The name of the symbol containing this symbol. This information is for
		user interface purposes (e.g. to render a qualifier in the user
		interface if necessary). It can't be used to re-infer a hierarchy for
		the document symbols.
	**/
	public var containerName:String;

	/**
		The kind of this symbol.
	**/
	public var kind:SymbolKind;

	/**
		Indicates if this symbol is deprecated.

		Deprecated. Use `tags` instead.
	**/
	public var deprecated:Bool;

	/**
		The location of this symbol. The location's range is used by a tool to
		reveal the location in the editor. If the symbol is selected in the tool
		the range's start information is used to position the cursor. So the
		range usually spans more then the actual symbol's name and does normally
		include things like visibility modifiers.

		The range doesn't have to denote a node range in the sense of a abstract
		syntax tree. It can therefore not be used to re-construct a hierarchy of
		the symbols.
	**/
	public var location:Location;

	/**
		Tags for this symbol.
	**/
	public var tags:Array<SymbolTag>;

	public function new() {}

	public static function parse(original:Dynamic):SymbolInformation {
		var vo = new SymbolInformation();
		vo.name = original.name;
		vo.kind = original.kind;
		vo.containerName = original.containerName;
		vo.deprecated = original.deprecated;
		vo.location = Location.parse(original.location);
		return vo;
	}
}

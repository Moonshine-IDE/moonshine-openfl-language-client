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
	Implementation of `DocumentSymbol` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_documentSymbol
**/
@:structInit
class DocumentSymbol {
	public static final FIELD_CHILDREN:String = "children";

	/**
		The name of this symbol. Will be displayed in the user interface and
		therefore must not be an empty string or a string only consisting of
		white spaces.
	**/
	public var name:String;

	/**
		More detail for this symbol, e.g the signature of a function.
	**/
	public var detail:String;

	/**
		The kind of this symbol.
	**/
	public var kind:SymbolKind;

	/**
		Tags for this document symbol.
	**/
	public var tags:Array<SymbolTag>;

	/**
		Indicates if this symbol is deprecated.

		Deprecated. Use tags instead
	**/
	public var deprecated:Bool;

	/**
		The range enclosing this symbol not including leading/trailing
		whitespace but everything else like comments. This information is
		typically used to determine if the clients cursor is inside the symbol
		to reveal in the symbol in the UI.
	**/
	public var range:Range;

	/**
		The range that should be selected and revealed when this symbol is being
		picked, e.g. the name of a function. Must be contained by the `range`.
	**/
	public var selectionRange:Range;

	/**
		Children of this symbol, e.g. properties of a class.
	**/
	public var children:Array<DocumentSymbol>;

	public function new() {}

	public static function parse(original:Dynamic):DocumentSymbol {
		var vo = new DocumentSymbol();
		vo.name = original.name;
		vo.detail = original.detail;
		vo.kind = original.kind;
		vo.deprecated = original.deprecated;
		vo.range = Range.parse(original.range);
		vo.selectionRange = Range.parse(original.selectionRange);
		if (Reflect.hasField(original, FIELD_CHILDREN)) {
			var jsonChildren = Reflect.field(original, FIELD_CHILDREN);
			var children:Array<DocumentSymbol> = [];
			for (child in cast(jsonChildren, Array<Dynamic>)) {
				children.push(DocumentSymbol.parse(child));
			}
			vo.children = children;
		}
		return vo;
	}
}

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
	Implementation of `Hover` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_hover
**/
@:structInit
class Hover {
	private static final FIELD_RANGE:String = "range";

	/**
		An optional range is a range inside a text document that is used to
		visualize a hover, e.g. by changing the background color.
	**/
	public var range:Range;

	/**
		The hover's content
	**/
	public var contents:Any; /* String | Array<String> | MarkedString | Array<MarkedString> | MarkupContent */

	public function new() {}

	public static function parse(original:Dynamic):Hover {
		var vo = new Hover();
		if (Reflect.hasField(original, FIELD_RANGE)) {
			vo.range = Range.parse(Reflect.field(original, FIELD_RANGE));
		}
		if ((original.contents is String)) {
			vo.contents = original.contents;
		} else if ((original.contents is Array)) {
			var contents:Array<Dynamic> = [];
			for (item in cast(original.contents, Array<Dynamic>)) {
				if ((item is String)) {
					contents.push(item);
				} else if (Reflect.hasField(original.contents, "language") && Reflect.hasField(original.contents, "value")) {
					contents.push(item); // MarkedString
				}
				vo.contents = contents;
			}
		} else if (Reflect.hasField(original.contents, "language") && Reflect.hasField(original.contents, "value")) {
			vo.contents = original.contents; // MarkedString
		} else if (Reflect.hasField(original.contents, "kind") && Reflect.hasField(original.contents, "value")) {
			vo.contents = MarkupContent.parse(original.contents);
		}
		return vo;
	}
}

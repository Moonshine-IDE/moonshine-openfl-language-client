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
	Implementation of `LocationLink` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#locationLink
**/
@:structInit
class LocationLink {
	private static final FIELD_ORIGIN_SELECTION_RANGE = "originSelectionRange";

	/**
		Span of the origin of this link.

		Used as the underlined span for mouse interaction. Defaults to the word
		range at the mouse position.
	**/
	public var originSelectionRange:Null<Range>;

	/**
		The target resource identifier of this link.
	**/
	public var targetUri:String;

	/**
		The full target range of this link. If the target for example is a symbol
		then target range is the range enclosing this symbol not including
		leading/trailing whitespace but everything else like comments. This
		information is typically used to highlight the range in the editor.
	**/
	public var targetRange:Range;

	/**
		The range that should be selected and revealed when this link is being
		followed, e.g the name of a function. Must be contained by the the
		`targetRange`. See also `DocumentSymbol.range`
	**/
	public var targetSelectionRange:Range;

	public function new(targetUri:String = null, targetRange:Range = null, targetSelectionRange:Range = null, originSelectionRange:Range = null) {
		this.targetUri = targetUri;
		this.targetRange = targetRange;
		this.targetSelectionRange = targetSelectionRange;
		this.originSelectionRange = originSelectionRange;
	}

	public static function parse(original:Dynamic):LocationLink {
		var vo = new LocationLink();
		if (Reflect.hasField(original, FIELD_ORIGIN_SELECTION_RANGE)) {
			var originSelectionRangeField = Reflect.field(original, FIELD_ORIGIN_SELECTION_RANGE);
			if (originSelectionRangeField != null) {
				vo.originSelectionRange = Range.parse(originSelectionRangeField);
			} else {
				vo.originSelectionRange = null;
			}
		}
		vo.targetUri = original.targetUri;
		vo.targetRange = Range.parse(original.targetRange);
		vo.targetSelectionRange = Range.parse(original.targetSelectionRange);
		return vo;
	}
}

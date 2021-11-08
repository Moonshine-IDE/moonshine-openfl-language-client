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
	Implementation of `ParameterInformation` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_signatureHelp
**/
@:structInit
class ParameterInformation {
	private static final FIELD_LABEL:String = "label";
	private static final FIELD_DOCUMENTATION:String = "documentation";

	/**
		The label of this parameter information.

		Either a string or an inclusive start and exclusive end offsets within
		its containing signature label. (see `SignatureInformation.label`). The
		offsets are based on a UTF-16 string representation as `Position` and
		`Range` does.

		*Note*: a label of type string should be a substring of its containing
		signature label. Its intended use case is to highlight the parameter
		label part in the `SignatureInformation.label`.
	**/
	public var label:String = "";

	/**
		The human-readable doc-comment of this parameter. Will be shown in the
		UI but can be omitted.
	**/
	public var documentation:Any /* String | MarkupContent */;

	public function new(label:String = null, documentation:String = null) {
		this.label = label;
		this.documentation = documentation;
	}

	public static function parse(original:Dynamic):ParameterInformation {
		var vo = new ParameterInformation();
		if (Reflect.hasField(original, FIELD_LABEL)) {
			vo.label = Reflect.field(original, FIELD_LABEL);
		}
		if (Reflect.hasField(original, FIELD_DOCUMENTATION)) {
			var documentation = Reflect.field(original, FIELD_DOCUMENTATION);
			if ((documentation is String)) {
				vo.documentation = documentation;
			} else if (documentation != null && Reflect.hasField(documentation, "kind") && Reflect.hasField(documentation, "value")) {
				vo.documentation = MarkupContent.parse(documentation);
			} else {
				vo.documentation = documentation;
			}
		}
		return vo;
	}
}

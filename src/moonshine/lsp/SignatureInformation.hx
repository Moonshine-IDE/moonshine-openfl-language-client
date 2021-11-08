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
	Implementation of `SignatureInformation` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_signatureHelp
**/
@:structInit
class SignatureInformation {
	private static final FIELD_LABEL:String = "label";
	private static final FIELD_PARAMETERS:String = "parameters";
	private static final FIELD_DOCUMENTATION:String = "documentation";
	private static final FIELD_ACTIVE_PARAMETER:String = "activeParameter";

	/**
		The label of this signature. Will be shown in the UI.
	**/
	public var label:String = "";

	/**
		The parameters of this signature.
	**/
	public var parameters:Array<ParameterInformation>;

	/**
		The index of the active parameter.

		If provided, this is used in place of `SignatureHelp.activeParameter`.
	**/
	public var activeParameter:Int = -1;

	/**
		The human-readable doc-comment of this signature. Will be shown in the
		UI but can be omitted.
	**/
	public var documentation:Any /* String | MarkupContent */ = null;

	public function new() {}

	public static function parse(original:Dynamic):SignatureInformation {
		var vo = new SignatureInformation();
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
		if (Reflect.hasField(original, FIELD_ACTIVE_PARAMETER)) {
			vo.activeParameter = Reflect.field(original, FIELD_ACTIVE_PARAMETER);
		}
		var parameters:Array<ParameterInformation> = [];
		if (Reflect.hasField(original, FIELD_PARAMETERS)) {
			var originalParams = cast(Reflect.field(original, FIELD_PARAMETERS), Array<Dynamic>);
			for (parameter in originalParams) {
				parameters.push(ParameterInformation.parse(parameter));
			}
		}
		vo.parameters = parameters;
		return vo;
	}
}

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
	Implementation of `Diagnostic` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#diagnostic
**/
class Diagnostic {
	private static final FIELD_CODE = "code";
	private static final FIELD_SEVERITY = "severity";

	public function new() {}

	/**
		The diagnostic's message.
	**/
	public var message:String;

	/**
		The range at which the message applies.
	**/
	public var range:Range;

	/**
		The diagnostic's severity. Can be omitted. If omitted it is up to the
		client to interpret diagnostics as error, warning, info or hint.
	**/
	public var severity:DiagnosticSeverity;

	/**
		The diagnostic's code, which might appear in the user interface.
	**/
	public var code:String;

	public static function parse(original:Dynamic):Diagnostic {
		var vo = new Diagnostic();
		vo.message = original.message;
		if (Reflect.hasField(original, FIELD_CODE)) {
			vo.code = Reflect.field(original, FIELD_CODE);
		}
		vo.range = Range.parse(original.range);
		if (Reflect.hasField(original, FIELD_SEVERITY)) {
			vo.severity = Reflect.field(original, FIELD_SEVERITY);
		}
		return vo;
	}
}

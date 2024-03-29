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
	Implementation of `SignatureHelp` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_signatureHelp
**/
@:structInit
class SignatureHelp {
	/**
		The active signature. If omitted or the value lies outside the
		range of `signatures` the value defaults to zero or is ignore if
		the `SignatureHelp` as no signatures.

		Whenever possible implementors should make an active decision about
		the active signature and shouldn't rely on a default value.

		In future version of the protocol this property might become
		mandatory to better express this.
	**/
	public var activeSignature:Int = -1;

	/**
		The active parameter of the active signature. If omitted or the value
		lies outside the range of `signatures[activeSignature].parameters`
		defaults to 0 if the active signature has parameters. If
		the active signature has no parameters it is ignored.
		In future version of the protocol this property might become
		mandatory to better express the active parameter if the
		active signature does have any.
	**/
	public var activeParameter:Int = -1;

	/**
		One or more signatures. If no signatures are available the signature
		help request should return `null`.
	**/
	public var signatures:Array<SignatureInformation>;

	public function new() {}

	public static function parse(original:Dynamic):SignatureHelp {
		var vo = new SignatureHelp();
		vo.activeSignature = original.activeSignature;
		vo.activeParameter = original.activeParameter;
		if (Reflect.hasField(original, "signatures")) {
			var originalSignatures = cast(original.signatures, Array<Dynamic>);
			vo.signatures = originalSignatures.map(signature -> SignatureInformation.parse(signature));
		} else {
			vo.signatures = [];
		}
		return vo;
	}
}

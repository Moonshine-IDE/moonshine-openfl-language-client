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
	Implementation of `SignatureHelpContext` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.

	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_signatureHelp
**/
typedef SignatureHelpContext = {
	/**
		Action that caused signature help to be triggered.
	**/
	triggerKind:SignatureHelpTriggerKind,

	/**
		Character that caused signature help to be triggered.

		This is undefined when
		`triggerKind !== SignatureHelpTriggerKind.TriggerCharacter`
	**/
	?triggerCharacter:String,

	/**
		`true` if signature help was already showing when it was triggered.

		Retriggers occur when the signature help is already active and can be
		caused by actions such as typing a trigger character, a cursor move, or
		document content changes.
	**/
	isRetrigger:Bool,

	/**
		The currently active `SignatureHelp`.

		The `activeSignatureHelp` has its `SignatureHelp.activeSignature` field
		updated based on the user navigating through available signatures.
	**/
	?activeSignatureHelp:SignatureHelp,
}

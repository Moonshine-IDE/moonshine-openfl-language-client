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
	Implementation of `CompletionTriggerKind` enumeration from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.

	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_completion
**/
@:enum
abstract CompletionTriggerKind(Int) from Int to Int {
	/**
		Completion was triggered by typing an identifier (24x7 code complete),
		manual invocation (e.g Ctrl+Space) or via API.
	**/
	var Invoked = 1;

	/**
		Completion was triggered by a trigger character specified by
		the `triggerCharacters` properties of the
		`CompletionRegistrationOptions`.
	**/
	var TriggerCharacter = 2;

	/**
		Completion was re-triggered as the current completion list is incomplete.
	**/
	var TriggerForIncompleteCompletions = 3;
}

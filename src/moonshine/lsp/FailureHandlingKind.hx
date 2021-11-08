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
	Implementation of `FailureHandlingKind` enumeration from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.

	@see https://microsoft.github.io/language-server-protocol/specification#failureHandlingKind
**/
@:enum
abstract FailureHandlingKind(String) from String to String {
	/**
		Applying the workspace change is simply aborted if one of the changes
		provided fails. All operations executed before the failing operation
		stay executed.
	**/
	var Abort = "abort";

	/**
		All operations are executed transactional. That means they either all
		succeed or no changes at all are applied to the workspace.
	**/
	var Transactional = "transactional";

	/**
		If the workspace edit contains only textual file changes they are
		executed transactional. If resource changes (create, rename or delete
		file) are part of the change the failure handling strategy is abort.
	**/
	var TextOnlyTransactional = "textOnlyTransactional";

	/**
		The client tries to undo the operations already executed. But there is
		no guarantee that this is succeeding.
	**/
	var Undo = "undo";
}

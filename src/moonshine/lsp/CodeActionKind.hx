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
	Implementation of `CodeActionKind` enumeration from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.

	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_codeAction
**/
@:enum
abstract CodeActionKind(String) from String to String {
	/**
		Empty kind.
	**/
	var Empty = "";

	/**
		Base kind for quickfix actions: 'quickfix'.
	**/
	var QuickFix = "quickfix";

	/**
		Base kind for refactoring actions: 'refactor'.
	**/
	var Refactor = "refactor";

	/**
		Base kind for refactoring extraction actions: 'refactor.extract'.

		Example extract actions:

		- Extract method
		- Extract function
		- Extract variable
		- Extract interface from class
		- ...
	**/
	var RefactorExtract = "refactor.extract";

	/**
		Base kind for refactoring inline actions: 'refactor.inline'.

		Example inline actions:

		- Inline function
		- Inline variable
		- Inline constant
		- ...
	**/
	var RefactorInline = "refactor.inline";

	/**
		Base kind for refactoring rewrite actions: 'refactor.rewrite'.

		Example rewrite actions:

		- Convert JavaScript function to class
		- Add or remove parameter
		- Encapsulate field
		- Make method static
		- Move method to base class
		- ...
	**/
	var RefactorRewrite = "refactor.rewrite";

	/**
		Base kind for source actions: `source`.

		Source code actions apply to the entire file.
	**/
	var Source = "source";

	/**
		Base kind for an organize imports source action:
		`source.organizeImports`.
	**/
	var SourceOrganizeImports = "source.organizeImports";

	/**
		Base kind for a 'fix all' source action: `source.fixAll`.

		'Fix all' actions automatically fix errors that have a clear fix that
		do not require user input. They should not suppress errors or perform
		unsafe fixes such as generating new types or classes.
	**/
	var SourceFixAll = "source.fixAll";
}

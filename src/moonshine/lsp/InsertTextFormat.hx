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
	Implementation of `InsertTextFormat` enumeration from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.

	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_completion
**/
#if haxe4 enum #else @:enum #end abstract InsertTextFormat(Int) from Int to Int {

	/**
		The primary text to be inserted is treated as a plain string.
	**/
	var PlainText = 1;

	/**
		The primary text to be inserted is treated as a snippet.

		A snippet can define tab stops and placeholders with `$1`, `$2`
		and `${3:foo}`. `$0` defines the final tab stop, it defaults to
		the end of the snippet. Placeholders with equal identifiers are linked,
		that is typing in one will update others too.
	**/
	var Snippet = 2;
}

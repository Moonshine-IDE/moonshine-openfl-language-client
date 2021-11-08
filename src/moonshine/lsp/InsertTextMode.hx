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
	Implementation of `InsertTextMode` enumeration from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.

	@see https://microsoft.github.io/language-server-protocol/specification#insertTextMode
**/
@:enum
abstract InsertTextMode(Int) from Int to Int {
	/**
		The insertion or replace strings is taken as it is. If the
		value is multi line the lines below the cursor will be
		inserted using the indentation defined in the string value.
		The client will not apply any kind of adjustments to the
		string.
	**/
	var asIs = 1;

	/**
		The editor adjusts leading whitespace of new lines so that
		they match the indentation up to the cursor of the line for
		which the item is accepted.

		Consider a line like this: <2tabs><cursor><3tabs>foo. Accepting a
		multi line completion item is indented using 2 tabs and all
		following lines inserted will be indented using 2 tabs as well.
	**/
	var adjustIndentation = 2;
}

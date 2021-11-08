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
	Implementation of `DidChangeTextDocumentParams` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.

	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_didChange
**/
typedef DidChangeTextDocumentParams = {
	/**
		The document that did change. The version number points
		to the version after all provided content changes have
		been applied.
	**/
	textDocument:VersionedTextDocumentIdentifier,

	/**
		The actual content changes. The content changes describe single state
		changes to the document. So if there are two content changes c1 (at
		array index 0) and c2 (at array index 1) for a document in state S then
		c1 moves the document from S to S' and c2 from S' to S''. So c1 is
		computed on the state S and c2 is computed on the state S'.

		To mirror the content of a document using change events use the following
		approach:
		- start with the same initial content
		- apply the 'textDocument/didChange' notifications in the order you
			receive them.
		- apply the `TextDocumentContentChangeEvent`s in a single notification
			in the order you receive them.
	**/
	contentChanges:TextDocumentContentChangeEvent,
}

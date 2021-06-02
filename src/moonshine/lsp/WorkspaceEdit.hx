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
	Implementation of `WorkspaceEdit` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#workspaceedit
**/
class WorkspaceEdit {
	private static final FIELD_CHANGES:String = "changes";
	private static final FIELD_DOCUMENT_CHANGES:String = "documentChanges";
	private static final FIELD_KIND:String = "kind";

	/**
		Holds changes to existing resources.

		The object key is the URI, and the value is an Array of `TextEdit`
		instances.
	 */
	public var changes:Map<String, Array<TextEdit>>;

	/**
		An array of TextDocumentEdits to express changes to n different
		text documents where each text document edit addresses a specific
		version of a text document. Or it can contain above TextDocumentEdits
		mixed with create, rename and delete file / folder operations.
	**/
	public var documentChanges:Array<Any>; // Array<TextDocumentEdit> | Array<TextDocumentEdit | CreateFile | DeleteFile | RenameFile>

	public function new() {}

	public static function parse(original:Dynamic):WorkspaceEdit {
		var vo = new WorkspaceEdit();
		if (Reflect.hasField(original, FIELD_CHANGES)) {
			var jsonChanges = Reflect.field(original, FIELD_CHANGES);
			var changes:Map<String, Array<TextEdit>> = [];
			for (uri in Reflect.fields(jsonChanges)) {
				// the key is the file path, the value is a list of TextEdits
				var jsonChangesForURI = Reflect.field(jsonChanges, uri);
				var textEdits:Array<TextEdit> = [];
				for (textEdit in cast(jsonChangesForURI, Array<Dynamic>)) {
					textEdits.push(TextEdit.parse(textEdit));
				}
				changes.set(uri, textEdits);
			}
			vo.changes = changes;
		}

		if (Reflect.hasField(original, FIELD_DOCUMENT_CHANGES)) {
			var jsonDocumentChanges = Reflect.field(original, FIELD_DOCUMENT_CHANGES);
			var documentChanges:Array<Any> = [];
			for (documentChange in cast(jsonDocumentChanges, Array<Dynamic>)) {
				if (Reflect.hasField(documentChange, FIELD_KIND)) {
					var documentChangeKind = Reflect.field(documentChange, FIELD_KIND);
					switch (documentChangeKind) {
						case RenameFile.KIND:
							documentChanges.push(RenameFile.parse(documentChange));
						case CreateFile.KIND:
							documentChanges.push(CreateFile.parse(documentChange));
						case DeleteFile.KIND:
							documentChanges.push(DeleteFile.parse(documentChange));
						default:
							trace("WorkspaceEdit.parse: Unknown document change:", documentChange.kind);
					}
				} else {
					documentChanges.push(TextDocumentEdit.parse(documentChange));
				}
			}
			vo.documentChanges = documentChanges;
		}
		return vo;
	}
}

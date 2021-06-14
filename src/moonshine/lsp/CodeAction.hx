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
	Implementation of `CodeAction` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_codeAction
**/
@:structInit
class CodeAction {
	private static final FIELD_DIAGNOSTICS:String = "diagnostics";
	private static final FIELD_EDIT:String = "edit";
	private static final FIELD_COMMAND:String = "command";

	/**
		A short, human-readable, title for this code action.
	**/
	public var title:String;

	/**
		The kind of the code action. Used to filter code actions.
	**/
	public var kind:CodeActionKind;

	/**
		The diagnostics that this code action resolves.
	**/
	public var diagnostics:Array<Diagnostic>;

	/**
		The workspace edit this code action performs.
	**/
	public var edit:WorkspaceEdit;

	/**
		A command this code action executes. If a code action provides an
		edit and a command, first the edit is executed and then the command.
	**/
	public var command:Command;

	public function new() {}

	public static function parse(original:Dynamic):CodeAction {
		var vo:CodeAction = new CodeAction();
		vo.title = original.title;
		vo.kind = original.kind;
		if (Reflect.hasField(original, FIELD_DIAGNOSTICS)) {
			var diagnostics:Array<Diagnostic> = [];
			var jsonDiagnostics = Reflect.field(original, FIELD_DIAGNOSTICS);
			for (diagnostic in cast(jsonDiagnostics, Array<Dynamic>)) {
				diagnostics.push(Diagnostic.parse(diagnostic));
			}
			vo.diagnostics = diagnostics;
		}
		if (Reflect.hasField(original, FIELD_EDIT)) {
			vo.edit = WorkspaceEdit.parse(Reflect.field(original, FIELD_EDIT));
		}
		if (Reflect.hasField(original, FIELD_COMMAND)) {
			vo.command = Command.parse(Reflect.field(original, FIELD_COMMAND));
		}
		return vo;
	}
}

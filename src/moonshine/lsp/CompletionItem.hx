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
	Implementation of `CompletionItem` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_completion
**/
@:structInit
class CompletionItem {
	private static final FIELD_COMMAND:String = "command";
	private static final FIELD_TEXT_EDIT:String = "textEdit";
	private static final FIELD_ADDITIONAL_TEXT_EDITS:String = "additionalTextEdits";
	private static final FIELD_LABEL:String = "label";
	private static final FIELD_INSERT_TEXT:String = "insertText";
	private static final FIELD_SORT_TEXT:String = "sortText";
	private static final FIELD_DOCUMENTATION:String = "documentation";
	private static final FIELD_DETAIL:String = "detail";
	private static final FIELD_DEPRECATED:String = "deprecated";
	private static final FIELD_DATA:String = "data";
	private static final FIELD_KIND:String = "kind";
	private static final FIELD_INSERT_TEXT_FORMAT:String = "insertTextFormat";

	public var label:String;

	public var sortText:String;

	public var kind:CompletionItemKind;

	public var detail:String;

	public var documentation:Any /* String | MarkupContent */;

	public var insertText:String = null;

	public var textEdit:TextEdit = null;

	public var insertTextFormat:InsertTextFormat = PlainText;

	/**
		An optional command that is executed *after* inserting this completion.
		*Note* that additional modifications to the current document should be
		described with the `additionalTextEdits` property.
	**/
	public var command:Command;

	/**
		An data entry field that is preserved on a completion item between a
		completion and a completion resolve request.
	**/
	public var data:Any;

	public var deprecated:Bool;

	public var additionalTextEdits:Array<TextEdit>;

	public function new() {}

	public static function resolve(item:CompletionItem, resolvedFields:Dynamic):CompletionItem {
		return populate(item, resolvedFields);
	}

	public static function parse(original:Dynamic):CompletionItem {
		var item:CompletionItem = new CompletionItem();
		return populate(item, original);
	}

	private static function populate(item:CompletionItem, resolvedFields:Dynamic):CompletionItem {
		if (Reflect.hasField(resolvedFields, FIELD_LABEL)) {
			item.label = Reflect.field(resolvedFields, FIELD_LABEL);
		}
		if (Reflect.hasField(resolvedFields, FIELD_SORT_TEXT)) {
			item.sortText = Reflect.field(resolvedFields, FIELD_SORT_TEXT);
		}
		if (Reflect.hasField(resolvedFields, FIELD_INSERT_TEXT)) {
			item.insertText = Reflect.field(resolvedFields, FIELD_INSERT_TEXT);
		}
		if (Reflect.hasField(resolvedFields, FIELD_INSERT_TEXT_FORMAT)) {
			item.insertTextFormat = Reflect.field(resolvedFields, FIELD_INSERT_TEXT_FORMAT);
		}
		if (Reflect.hasField(resolvedFields, FIELD_KIND)) {
			item.kind = Reflect.field(resolvedFields, FIELD_KIND);
		}
		if (Reflect.hasField(resolvedFields, FIELD_DETAIL)) {
			item.detail = Reflect.field(resolvedFields, FIELD_DETAIL);
		}
		if (Reflect.hasField(resolvedFields, FIELD_DOCUMENTATION)) {
			var documentation = Reflect.field(resolvedFields, FIELD_DOCUMENTATION);
			if ((documentation is String)) {
				item.documentation = documentation;
			} else if (documentation != null && Reflect.hasField(documentation, "kind") && Reflect.hasField(documentation, "value")) {
				item.documentation = MarkupContent.parse(documentation);
			} else {
				item.documentation = documentation;
			}
		}
		if (Reflect.hasField(resolvedFields, FIELD_DEPRECATED)) {
			item.deprecated = Reflect.field(resolvedFields, FIELD_DEPRECATED) == true;
		}
		if (Reflect.hasField(resolvedFields, FIELD_COMMAND)) {
			item.command = Command.parse(Reflect.field(resolvedFields, FIELD_COMMAND));
		}
		if (Reflect.hasField(resolvedFields, FIELD_TEXT_EDIT)) {
			item.textEdit = TextEdit.parse(Reflect.field(resolvedFields, FIELD_TEXT_EDIT));
		}
		if (Reflect.hasField(resolvedFields, FIELD_ADDITIONAL_TEXT_EDITS)) {
			var additionalTextEdits:Array<TextEdit> = [];
			var jsonAdditionalTextEdits = Reflect.field(resolvedFields, FIELD_ADDITIONAL_TEXT_EDITS);
			for (jsonTextEdit in cast(jsonAdditionalTextEdits, Array<Dynamic>)) {
				additionalTextEdits.push(TextEdit.parse(jsonTextEdit));
			}
			item.additionalTextEdits = additionalTextEdits;
		}
		if (Reflect.hasField(resolvedFields, FIELD_DATA)) {
			item.data = Reflect.field(resolvedFields, FIELD_DATA);
		}
		return item;
	}

	public function toJSON(key:String):Any {
		var result:Dynamic = {};
		result.label = this.label;
		result.kind = this.kind;
		result.deprecated = this.deprecated;
		result.insertTextFormat = this.insertTextFormat;
		if (this.detail != null) {
			result.detail = this.detail;
		}
		if (this.documentation != null) {
			result.documentation = this.documentation;
		}
		if (this.command != null) {
			result.command = this.command;
		}
		if (this.data != null) {
			result.data = this.data;
		}
		if (this.additionalTextEdits != null) {
			var additionalTextEdits:Array<TextEdit> = [];
			for (textEdit in this.additionalTextEdits) {
				additionalTextEdits.push(textEdit);
			}
			result.additionalTextEdits = additionalTextEdits;
		}
		return result;
	}
}

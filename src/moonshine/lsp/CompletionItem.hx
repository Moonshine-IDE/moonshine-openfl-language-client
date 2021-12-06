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
	private static final FIELD_FILTER_TEXT:String = "filterText";
	private static final FIELD_DOCUMENTATION:String = "documentation";
	private static final FIELD_DETAIL:String = "detail";
	private static final FIELD_DEPRECATED:String = "deprecated";
	private static final FIELD_DATA:String = "data";
	private static final FIELD_KIND:String = "kind";
	private static final FIELD_INSERT_TEXT_FORMAT:String = "insertTextFormat";

	/**
		The label of this completion item.

		The label property is also by default the text that
		is inserted when selecting this completion.

		If label details are provided the label itself should
		be an unqualified name of the completion item.
	**/
	public var label:String;

	/**
		A string that should be used when comparing this item
		with other items. When `falsy` the label is used
		as the sort text for this item.
	**/
	public var sortText:String;

	/**
		A string that should be used when filtering a set of
		completion items. When `falsy` the label is used as the
		filter text for this item.
	**/
	public var filterText:String;

	/**
		The kind of this completion item. Based of the kind
		an icon is chosen by the editor. The standardized set
		of available values is defined in `CompletionItemKind`.
	**/
	public var kind:CompletionItemKind;

	/**
		A human-readable string with additional information
		about this item, like type or symbol information.
	**/
	public var detail:String;

	/**
		A human-readable string that represents a doc-comment.
	**/
	public var documentation:Any /* String | MarkupContent */;

	/**
		A string that should be inserted into a document when selecting
		this completion. When `falsy` the label is used as the insert text
		for this item.

		The `insertText` is subject to interpretation by the client side.
		Some tools might not take the string literally. For example
		VS Code when code complete is requested in this example
		`con<cursor position>` and a completion item with an `insertText` of
		`console` is provided it will only insert `sole`. Therefore it is
		recommended to use `textEdit` instead since it avoids additional client
		side interpretation.
	**/
	public var insertText:String = null;

	/**
		An edit which is applied to a document when selecting this completion.
		When an edit is provided the value of `insertText` is ignored.

		*Note:* The range of the edit must be a single line range and it must
		contain the position at which completion has been requested.
	**/
	public var textEdit:TextEdit = null;

	/**
		The format of the insert text. The format applies to both the
		`insertText` property and the `newText` property of a provided
		`textEdit`. If omitted defaults to `InsertTextFormat.PlainText`.

		Please note that the insertTextFormat doesn't apply to
		`additionalTextEdits`.
	**/
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

	/**
		Indicates if this item is deprecated.

		Deprecated. Use `tags` instead if supported.
	**/
	public var deprecated:Bool;

	/**
		Tags for this completion item.
	**/
	public var tags:Array<CompletionItemTag>;

	/**
		An optional array of additional text edits that are applied when
		selecting this completion. Edits must not overlap (including the same
		insert position) with the main edit nor with themselves.

		Additional text edits should be used to change text unrelated to the
		current cursor position (for example adding an import statement at the
		top of the file if the completion item will insert an unqualified type).
	**/
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
		if (Reflect.hasField(resolvedFields, FIELD_FILTER_TEXT)) {
			item.filterText = Reflect.field(resolvedFields, FIELD_FILTER_TEXT);
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
}

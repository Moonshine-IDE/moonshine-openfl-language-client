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
	Implementation of `SymbolInformation` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.
	 
	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_documentSymbol
	@see https://microsoft.github.io/language-server-protocol/specification#workspace_symbol
**/
@:structInit
class SymbolInformation {
	public var name:String;
	public var containerName:String;
	public var kind:SymbolKind;
	public var deprecated:Bool;
	public var location:Location;

	public function new() {}

	public static function parse(original:Dynamic):SymbolInformation {
		var vo = new SymbolInformation();
		vo.name = original.name;
		vo.kind = original.kind;
		vo.containerName = original.containerName;
		vo.deprecated = original.deprecated;
		vo.location = Location.parse(original.location);
		return vo;
	}
}

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
	Implementation of `PublishDiagnosticsParams` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.

	@see https://microsoft.github.io/language-server-protocol/specification#textDocument_publishDiagnostics
**/
@:structInit
class PublishDiagnosticsParams {
	public function new(uri:String, version:Null<Int>, diagnostics:Array<Diagnostic>) {
		this.uri = uri;
		this.version = version;
		this.diagnostics = diagnostics;
	}

	/**
		The URI for which diagnostic information is reported.
	**/
	public var uri:String;

	/**
		Optional the version number of the document the diagnostics are
		published for.
	**/
	public var version:Null<Int> = null;

	/**
		An array of diagnostic information items.
	**/
	public var diagnostics:Array<Diagnostic>;

	public static function parse(jsonParams:Any):PublishDiagnosticsParams {
		var uri:String = Reflect.field(jsonParams, "uri");
		var version:Null<Int> = null;
		if (Reflect.hasField(jsonParams, "version")) {
			version = Reflect.field(jsonParams, "version");
		}
		var jsonDiagnostics:Array<Any> = Reflect.field(jsonParams, "diagnostics");
		var diagnostics = jsonDiagnostics.map(jsonResult -> Diagnostic.parse(jsonResult));
		return {
			uri: uri,
			version: version,
			diagnostics: diagnostics
		}
	}
}

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
	Implementation of `UnegistrationParams` interface from Language Server Protocol

	**DO NOT** add new properties or methods to this class that are specific to
	Moonshine IDE or to a particular language. Create a subclass for new
	properties or create a utility function for methods.

	@see https://microsoft.github.io/language-server-protocol/specification#client_unregisterCapability
**/
@:structInit
class UnregistrationParams {
	public function new(unregistrations:Array<Unregistration>) {
		this.unregistrations = unregistrations;
	}

	/**
		The unregistrations.
	**/
	public var unregistrations:Array<Unregistration>;

	public static function parse(jsonParams:Any):UnregistrationParams {
		// unregisterations is correct. the language server protocol
		// specification includes the typo. it may be fixed in a future major
		// version of the specification, but it remains for now.
		var jsonUnregistrations:Array<Any> = Reflect.field(jsonParams, "unregisterations");
		var unregistrations = jsonUnregistrations.map(jsonResult -> Unregistration.parse(jsonResult));
		return {
			unregistrations: unregistrations
		};
	}
}

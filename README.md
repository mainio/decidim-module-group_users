# Decidim::GroupUsers

This module restores some of the legacy User Groups functionality that was deprecated and removed in Decidim 0.31 (https://github.com/decidim/decidim/pull/14130).

While Decidim core has migrated User Groups into regular participants with shared credentials, some usecases still rely on the ability for participants to act on behalf of a group when participating in the platform. This module brings back selected pieces of that functionality.

#### Comment as group

Restores the `comment_as` selector in the comment form, allowing verified participants to choose whether they want to post a comment as themselves or on behalf of a user group they belong to.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-group_users", git: "git@github.com:mainio/decidim-module-group_users.git"
```

And then execute:

```bash
$ bundle install
```

## Usage

Once installed, the `comment_as` dropdown will reappear in comment forms across the platform. Participants who belong to a verified user group will be able to select that group when posting a comment, and the comment will be attributed accordingly.

No further configuration is required for the basic feature to work.

## Compatibility

This module is intended for Decidim 0.31 and above, where the original User Groups feature has been removed from core.

## Contributing

See [Decidim's contributing guide](https://github.com/decidim/decidim/blob/develop/CONTRIBUTING.adoc).

## License

This engine is distributed under the [GNU Affero General Public License v3.0](LICENSE-AGPLv3.txt).
resource "github_repository" "netframe-ter" {
  name = "astanil/netframe-ter"
}

resource "github_actions_runner_group" "example" {
  name                    = default
  visibility              = "selected"
  selected_repository_ids = [github_repository.netframe-ter.repo_id]
}
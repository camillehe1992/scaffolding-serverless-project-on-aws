"""Infrastructure contract tests for deployment configuration."""

import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[3]


class InfrastructureContractsTest(unittest.TestCase):
    """Validate deployment files needed for prod automation."""

    def test_prod_environment_is_wired_for_local_and_github_actions(self) -> None:
        prod_units = ("security", "dynamodb", "api")
        for unit in prod_units:
            terragrunt_file = (
                REPO_ROOT / "terraform" / "environments" / "prod" / unit / "terragrunt.hcl"
            )
            self.assertTrue(terragrunt_file.exists())
            self.assertTrue(terragrunt_file.read_text(encoding="utf-8").strip())

        deploy_workflow = (
            REPO_ROOT / ".github" / "workflows" / "terragrunt-unit-deploy.yml"
        ).read_text(encoding="utf-8")
        destroy_workflow = (
            REPO_ROOT / ".github" / "workflows" / "terragrunt-unit-destroy.yml"
        ).read_text(encoding="utf-8")
        prod_full_deploy_workflow = REPO_ROOT / ".github" / "workflows" / "deploy-prod.yml"

        self.assertIn("- prod", deploy_workflow)
        self.assertIn("- prod", destroy_workflow)
        self.assertTrue(prod_full_deploy_workflow.exists())


if __name__ == "__main__":
    unittest.main()

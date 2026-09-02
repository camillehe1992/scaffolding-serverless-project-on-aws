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

    def test_deploy_dev_workflow_only_runs_for_deployment_relevant_paths(self) -> None:
        deploy_dev_workflow = (
            REPO_ROOT / ".github" / "workflows" / "deploy-dev.yml"
        ).read_text(encoding="utf-8")

        self.assertIn("paths:", deploy_dev_workflow)
        self.assertIn("- \".github/workflows/**\"", deploy_dev_workflow)
        self.assertIn("- \"scripts/build-dependencies-zip.sh\"", deploy_dev_workflow)
        self.assertIn("- \"src/**\"", deploy_dev_workflow)
        self.assertIn("- \"terraform/**\"", deploy_dev_workflow)

    def test_reusable_terragrunt_workflow_enables_provider_cache(self) -> None:
        reusable_workflow = (
            REPO_ROOT / ".github" / "workflows" / "reusable-terragrunt-deploy.yml"
        ).read_text(encoding="utf-8")

        self.assertIn("TF_PLUGIN_CACHE_DIR", reusable_workflow)
        self.assertIn("plugin_cache_dir", reusable_workflow)
        self.assertIn("actions/cache@v4", reusable_workflow)

    def test_api_build_uses_pip_cache(self) -> None:
        reusable_workflow = (
            REPO_ROOT / ".github" / "workflows" / "reusable-terragrunt-deploy.yml"
        ).read_text(encoding="utf-8")
        build_dependencies_script = (
            REPO_ROOT / "scripts" / "build-dependencies-zip.sh"
        ).read_text(encoding="utf-8")

        self.assertIn("cache: pip", reusable_workflow)
        self.assertIn("cache-dependency-path: src/requirements.txt", reusable_workflow)
        self.assertNotIn("--no-cache-dir", build_dependencies_script)


if __name__ == "__main__":
    unittest.main()

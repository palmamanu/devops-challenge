import pytest
import tftest

@pytest.fixture(scope="session")
def terraform_dir():
    return "../"  


@pytest.fixture
def plan(terraform_dir, module_name="modules/app_module"):
  tf = tftest.TerraformTest(module_name, terraform_dir)
  tf.setup()
  return tf.plan(output=True)


def test_variables(plan):
  assert plan.variables['timezone'] == "America/New_York"
  assert plan.variables['chart_path'] == "../app1"
  assert plan.variables['chart_name'] == "app1"


  


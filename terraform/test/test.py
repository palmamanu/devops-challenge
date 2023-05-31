import pytest
import tftest

@pytest.fixture(scope="session")
def terraform_dir():
    return "../"  # Reemplaza con la ruta a tu directorio de Terraform



@pytest.fixture
def plan(terraform_dir, module_name="modules/app_module"):
  tf = tftest.TerraformTest(module_name, terraform_dir)
  tf.setup()
  return tf.plan(output=True)


def test_variables(plan):
  # assert 'prefix' in plan.variables
  assert plan.variables['timezone'] == "America/New_York"
  


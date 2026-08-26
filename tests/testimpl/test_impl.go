// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package testimpl

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	ec2types "github.com/aws/aws-sdk-go-v2/service/ec2/types"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func getEC2Client(t *testing.T) *ec2.Client {
	cfg, err := config.LoadDefaultConfig(context.Background())
	require.NoError(t, err, "Failed to load AWS config")
	return ec2.NewFromConfig(cfg)
}

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	TestComposableCompleteReadonly(t, ctx)
}

func TestComposableCompleteReadonly(t *testing.T, ctx types.TestContext) {
	t.Run("TestTerraformOutputs", func(t *testing.T) {
		opts := ctx.TerratestTerraformOptions()
		id := terraform.Output(t, opts, "id")
		vpcID := terraform.Output(t, opts, "vpc_id")
		tgwID := terraform.Output(t, opts, "transit_gateway_id")
		assert.NotEmpty(t, id)
		assert.NotEmpty(t, vpcID)
		assert.NotEmpty(t, tgwID)
	})

	t.Run("TestAttachmentViaAPI", func(t *testing.T) {
		client := getEC2Client(t)
		id := terraform.Output(t, ctx.TerratestTerraformOptions(), "id")
		out, err := client.DescribeTransitGatewayVpcAttachments(context.Background(), &ec2.DescribeTransitGatewayVpcAttachmentsInput{
			TransitGatewayAttachmentIds: []string{id},
		})
		require.NoError(t, err, "DescribeTransitGatewayVpcAttachments should succeed")
		require.Len(t, out.TransitGatewayVpcAttachments, 1)
		att := out.TransitGatewayVpcAttachments[0]
		assert.Equal(t, ec2types.TransitGatewayAttachmentStateAvailable, att.State)
		assert.Equal(t, terraform.Output(t, ctx.TerratestTerraformOptions(), "vpc_id"), aws.ToString(att.VpcId))
		assert.Equal(t, terraform.Output(t, ctx.TerratestTerraformOptions(), "transit_gateway_id"), aws.ToString(att.TransitGatewayId))
	})
}

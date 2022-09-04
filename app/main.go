package main

import (
  "fmt"
	"os"
	"github.com/hashicorp/hcl/v2/hclwrite"
	"github.com/zclconf/go-cty/cty"
)

func main(){

  // args                  := os.Args
  parameterName         := os.Args[1]
  parameterKey          := os.Args[2]
  parameterValue        := os.Args[3]
  parameterDescription  := os.Args[4]
  parameterType         := os.Args[5]
  parameterEnv          := os.Args[6]

  terraformFile := "main.tf"

  fmt.Println(parameterName)
  fmt.Println(parameterKey)
  fmt.Println(parameterValue)
  fmt.Println(parameterDescription)
  fmt.Println(parameterType)
  fmt.Println(parameterEnv)

  createResource(terraformFile, parameterName, parameterKey, parameterDescription, parameterType, parameterValue, parameterEnv)
}


func createResource(terraformFile, nameResource, nameParameter, description, Parametertype, value, env string){
  hclFile := hclwrite.NewEmptyFile()

  filename := terraformFile
  tfFile, err := os.OpenFile(filename, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
  if err != nil {
    fmt.Println(err)
    return
  }

  rootBody := hclFile.Body()
  // rootBody.AppendNewline()
  rs := rootBody.AppendNewBlock("resource", []string{"aws_ssm_parameter", fmt.Sprintf(nameResource)})
  rsBody := rs.Body()
  rsBody.SetAttributeValue("name", cty.StringVal(fmt.Sprint(nameParameter)))
  rsBody.SetAttributeValue("description", cty.StringVal(fmt.Sprint(description)))
  rsBody.SetAttributeValue("type", cty.StringVal(fmt.Sprint(Parametertype)))
  rsBody.SetAttributeValue("value", cty.StringVal(fmt.Sprint(value)))

  tagBlock := rsBody.AppendNewBlock("tags =", nil)
  tagBlockBody := tagBlock.Body()
  tagBlockBody.SetAttributeValue("environment", cty.StringVal(fmt.Sprint(env)))
  rootBody.AppendNewline()

  tfFile.Write(hclFile.Bytes())
}

/* Copyright 2024 The OpenXLA Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#ifndef XLA_BACKENDS_GPU_CODEGEN_TRITON_IR_TRITON_XLA_ATTRS_TD_
#define XLA_BACKENDS_GPU_CODEGEN_TRITON_IR_TRITON_XLA_ATTRS_TD_

include "triton/Dialect/TritonGPU/IR/TritonGPUAttrDefs.td"
include "xla/backends/gpu/codegen/triton/ir/triton_xla_dialect.td"

class TTXLA_Attr<string name, list<Trait> traits = []> :
      AttrDef<XlaTritonDialect, name, traits> {
}

def XLA_TmaDescriptorAttr : TTXLA_Attr<"TmaDescriptor"> {
  let summary = "Contains the necessary data to generate TMA descriptors.";
  let mnemonic = "tma_descriptor";
  let parameters = (ins
    ArrayRefParameter<"int64_t", "">:$global_shape,
    ArrayRefParameter<"int64_t", "">:$block_shape,
    ArrayRefParameter<"int64_t", "">:$layout,
    "int":$element_byte_size,
    // Swizzle mode corresponds to the enum CUtensorMapSwizzle
    // https://docs.nvidia.com/cuda/cuda-driver-api/group__CUDA__TYPES.html#group__CUDA__TYPES_1g0bc04417bd8ce2c64d204bc3cbc25b58
    "unsigned":$swizzle_mode
  );
  let hasCustomAssemblyFormat = 1;
  let builders = [
      AttrBuilder<(ins
            "ArrayRef<int64_t>":$global_shape,
            "ArrayRef<int64_t>":$block_shape,
            "ArrayRef<int64_t>":$layout,
            "int":$element_byte_size), [{
            // Swizzle mode is decided later in the pipeline than these TMA
            // descriptors are first created. Set it to a default 0 until it can
            // be filled in correctly later.
            return $_get(context, global_shape, block_shape, layout,
            element_byte_size, /*swizzle_mode=*/0);
      }]>
  ];
}

#endif // XLA_BACKENDS_GPU_CODEGEN_TRITON_IR_TRITON_XLA_ATTRS_TD_

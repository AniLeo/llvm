"""Generate a mock model for LLVM tests for Register Allocation.
The generated model is not a neural net - it is just a tf.function with the
correct input and output parameters. By construction, the mock model will always
output the first liverange that can be evicted.
"""
import os
import sys
import tensorflow as tf
POLICY_DECISION_LABEL = 'index_to_evict'
POLICY_OUTPUT_SPEC = """
[
    {
        "logging_name": "index_to_evict",
        "tensor_spec": {
            "name": "StatefulPartitionedCall",
            "port": 0,
            "type": "int64_t",
            "shape": [
                1
            ]
        }
    }
]
"""
PER_REGISTER_INT64_FEATURE_LIST = [
    'mask', 'is_hint', 'is_local', 'is_free', 'max_stage', 'min_stage'
]
PER_REGISTER_FLOAT32_FEATURE_LIST = ['nr_urgent',
    'weighed_reads_by_max', 'weighed_writes_by_max',
    'weighed_read_writes_by_max', 'weighed_indvars_by_max',
    'hint_weights_by_max', 'start_bb_freq_by_max', 'end_bb_freq_by_max',
    'hottest_bb_freq_by_max', 'liverange_size', 'use_def_density',
    'nr_defs_and_uses', 'nr_broken_hints', 'nr_rematerializable'
]
PER_REGISTER_FEATURE_LIST = PER_REGISTER_FLOAT32_FEATURE_LIST + \
    PER_REGISTER_INT64_FEATURE_LIST
CONTEXT_FEATURE_LIST = ('progress', 'discount', 'reward', 'step_type')
NUM_REGISTERS = 33


def get_input_signature():
  """Returns (time_step_spec, action_spec) for LLVM register allocation."""
  inputs = dict(
      (key, tf.TensorSpec(dtype=tf.int64, shape=(NUM_REGISTERS), name=key))
      for key in PER_REGISTER_INT64_FEATURE_LIST)
  inputs.update(
      dict((key,
            tf.TensorSpec(dtype=tf.float32, shape=(NUM_REGISTERS), name=key))
           for key in PER_REGISTER_FLOAT32_FEATURE_LIST))
  inputs['progress'] = tf.TensorSpec(
      dtype=tf.float32, shape=(), name='progress')
  inputs.update(
      dict((key, tf.TensorSpec(dtype=tf.float32, shape=(), name=key))
           for key in ['discount', 'reward']))
  inputs.update(
      dict((key, tf.TensorSpec(dtype=tf.int32, shape=(), name=key))
           for key in ['step_type']))
  return inputs


def get_output_spec_path(path):
  return os.path.join(path, 'output_spec.json')


def build_mock_model(path):
  """Build and save the mock model with the given signature."""
  module = tf.Module()
  # We have to set this useless variable in order for the TF C API to correctly
  # intake it
  module.var = tf.Variable(0, dtype=tf.int64)

  def action(*inputs):
    s1 = tf.reduce_sum([
        tf.cast(inputs[0][key], tf.float32) for key in PER_REGISTER_FEATURE_LIST
    ],
        axis=0)
    s2 = tf.reduce_sum(
        [tf.cast(inputs[0][key], tf.float32) for key in CONTEXT_FEATURE_LIST])
    # Add a large number so s won't be 0.
    s = s1 + s2 + 123456789.123456789
    # Equals to mask feature.
    mask_alias = tf.not_equal(s * tf.cast(inputs[0]['mask'], tf.float32), 0)
    result = tf.math.argmax(mask_alias, axis=-1) + module.var
    return {POLICY_DECISION_LABEL: result}
  module.action = tf.function()(action)
  action = {
      'action': module.action.get_concrete_function(get_input_signature())
  }
  tf.saved_model.save(module, path, signatures=action)
  output_spec_path = get_output_spec_path(path)
  with open(output_spec_path, 'w') as f:
    print(f'Writing output spec to {output_spec_path}.')
    f.write(POLICY_OUTPUT_SPEC)


def main(argv):
  assert len(argv) == 2
  model_path = argv[1]
  build_mock_model(model_path)


if __name__ == '__main__':
  main(sys.argv)

#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'
load 'test_helper/bats-file/load'

setup() {
  # Create a temporary scratch directory for the shell script to work in.
  BATS_TMPDIR=$(temp_make)

  # The comments below disable a shellcheck warning that would
  # otherwise appear on both these saying that these variables
  # appear to be unused. They *are* used, but in the bats-file
  # code, so shellcheck can't tell they're being used, which is
  # why I'm ignoring those checks for these two variables, and
  # BATSLIB_TEMP_PRESERVE_ON_FAILURE a little farther down.
  # shellcheck disable=SC2034
  BATSLIB_FILE_PATH_REM="#${BATS_TMPDIR}"
  # shellcheck disable=SC2034
  BATSLIB_FILE_PATH_ADD='<temp>'

  # Comment out the next line if you want to see where the temp files
  # are being created.
  echo "Bats temp directory: $BATS_TMPDIR"

  # This tells bats to preserve (i.e., not delete)
  # the temp files generated for failing tests. This might be 
  # useful in trying to figure out what happened when a test fails.
  # It also could potentially clutter up the drive with a bunch
  # of temp files, so you might want to disable it when you're not
  # in "full-on debugging" mode.
  # shellcheck disable=SC2034
  BATSLIB_TEMP_PRESERVE_ON_FAILURE=1

  cp -R bin "$BATS_TMPDIR"/bin
  cp -R html_components "$BATS_TMPDIR"/html_components
  cp -R etc "$BATS_TMPDIR"/etc
  cp -R examples "$BATS_TMPDIR"/examples
  cp -R log_files "$BATS_TMPDIR"/log_files
  cp -R tests "$BATS_TMPDIR"/tests

  # Go into the scratch directory to do all the work.
  cd "$BATS_TMPDIR" || exit 1
}

# Remove the file generated by the tested script.
teardown() {
  temp_del "$BATS_TMPDIR"
}

# If this test fails, your script file doesn't exist, or there's
# a typo in the name, or it's in the wrong directory, etc.
@test "bin/process_logs.sh exists" {
  assert_file_exist "bin/process_logs.sh"
}

# If this test fails, your script isn't executable.
@test "bin/process_logs.sh is executable" {
  assert_file_executable "bin/process_logs.sh"
}

# If this test fails, your script either didn't run at all, or it
# generated some sort of error when it ran.
@test "bin/process_logs.sh runs successfully" {
  run bin/process_logs.sh log_files/*_secure.tgz
  assert_success
}

# If this test fails, your script didn't generate the correct HTML
# for the bar chart for the hour data from discovery and velcro.
@test "bin/process_logs.sh generates correct simple output" {
  bin/process_logs.sh log_files/*_secure.tgz
  mkdir targets
  sort tests/summary_plots.html > targets/target.txt
  sort failed_login_summary.html > targets/sorted.txt
  run diff -wbB targets/target.txt targets/sorted.txt
  assert_success
}

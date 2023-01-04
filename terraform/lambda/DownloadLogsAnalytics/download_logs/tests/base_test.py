from nose.tools import assert_equal
from download_logs.base import Base


def test_base():
    log_file = "2017-05-26T10-00-00.000-wZe41G6PdJYziQ8AAAAA.log"
    base = Base(log_file)
    assert_equal(base.filename, log_file)

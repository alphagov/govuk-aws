class Base(object):

    def __init__(self, filename):
        self.filename = filename

    def open_for_read(self):
        raise NotImplementedError

    def open_for_write(self, path):
        raise NotImplementedError

    def process(self):
        raise NotImplementedError

    def transform_row(self, row):
        raise NotImplementedError

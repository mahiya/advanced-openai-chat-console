import os, uuid

class tmpfile(object):
    
    def __init__(self, file_bytes):
        self.file_bytes = file_bytes

    def __enter__(self, *args):
        self.tmp_file_name = str(uuid.uuid4())
        with open(self.tmp_file_name, 'wb') as f:
            f.write(self.file_bytes)
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        os.remove(self.tmp_file_name)

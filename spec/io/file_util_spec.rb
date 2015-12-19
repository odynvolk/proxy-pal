require 'spec_helper'
require 'io/file_util'

describe FileUtil do
  before(:all) do
    @filename = './spec/fixtures/test.tmp'
  end

  describe "string files" do
    it "write and read a plain string file" do
      content = 'abc'

      FileUtil.write_string(@filename, content)
      file = FileUtil.read_string(@filename)

      expect(file).to eq(content)
    end
  end

  describe "yml files" do
    it "write and read a yml stringfile" do
      content = {'a' => 1, 'b' => 2}

      FileUtil.write_yml(@filename, content)
      file = FileUtil.read_yml(@filename)

      expect(file['a']).to eq(1)
      expect(file['b']).to eq(2)
    end
  end

end
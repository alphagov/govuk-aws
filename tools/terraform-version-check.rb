terraform_version = "\"= 0.11.1\""

@all_tf_version_files = []
@uptodate_tf_version_files = []

Dir['terraform/projects/*/main.tf'].each do |file|
  @all_tf_version_files << %x[grep -H 'required_version =' #{file} | sort | awk '{ print $1 }' | sed 's/://'].split(" ")
  @uptodate_tf_version_files << %x[grep -H 'required_version = #{terraform_version}' #{file} | sort | awk '{ print $1 }' | sed 's/://'].split(" ")
end

old_tf_versions = (@all_tf_version_files - @uptodate_tf_version_files).join(", ")
verb = old_tf_versions.split(", ").count > 1 ? "are" : "is"
if old_tf_versions.split(", ").count > 0
  puts "#{old_tf_versions} #{verb} not on Terraform version #{terraform_version.split("= ")[1].chomp('"')}."
  exit 1
end

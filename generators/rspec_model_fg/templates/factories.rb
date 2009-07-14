Factory.define :<%= file_name %> do |f|
<% attributes.each do |attribute| -%>
<%= "\tf.#{attribute.name}\t#{attribute.default_for_factory}\n" -%>
<% end -%>
end

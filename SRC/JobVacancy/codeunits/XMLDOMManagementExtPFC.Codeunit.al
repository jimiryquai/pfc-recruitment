codeunit 50106 XMLDOMManagementExt_PFC
{

    trigger OnRun()
    begin
    end;

    procedure AddElement(var pXMLNode: XmlNode; pNodeName: Text; pNodeText: Text; pNameSpace: Text; var pCreatedNode: XmlNode): Boolean
    var
        lNewChildNode: XmlNode;
    begin
        if pNodeText <> '' then
            lNewChildNode := XmlElement.Create(pNodeName, pNameSpace, pNodeText).AsXmlNode()
        else
            lNewChildNode := XmlElement.Create(pNodeName, pNameSpace).AsXmlNode();
        if pXMLNode.AsXmlElement().Add(lNewChildNode) then begin
            pCreatedNode := lNewChildNode;
            exit(true);
        end;
    end;

    procedure XMLEscape(pText: Text): Text
    var
        lXMLDocument: XmlDocument;
        lRootXmlNode: XmlNode;
        lXmlNode: XmlNode;
    begin
        lXMLDocument := XmlDocument.Create();
        AddElement(lRootXmlNode, 'XMLEscape', pText, '', lXmlNode);
        exit(lXmlNode.AsXmlElement().InnerXml());
    end;
}

{
  MIT License

  Copyright (c) 2017 Marcos Douglas B. Santos

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
}
unit Xavier.Core.Tests;

{$include xavier.inc}

interface

uses
  Classes, SysUtils,
  James.Data,
  James.Data.Clss,
  James.IO,
  James.IO.Clss,
  James.Testing.Clss,
  Xavier.Core.Clss;

type
  TXMLFileForTest = class(TFile)
  public
    class function New: IFile; reintroduce;
  end;

  TXMLStreamForTest = class(TDataStream)
  public
    class function New: IDataStream; reintroduce;
  end;

  TXMLPackTest = class(TTestCase)
  published
    procedure Load;
    procedure XPath;
  end;

  TXMLNodeTest = class(TTestCase)
  published
    procedure Name;
    procedure Value;
    procedure Attrs;
    procedure Childs;
    procedure Up;
  end;

  TXMLAttributeTest = class(TTestCase)
  published
    procedure Name;
    procedure Value;
  end;

implementation

{ TXMLFileForTest }

class function TXMLFileForTest.New: IFile;
begin
  Result := inherited New('..\pkg\xavier.lpk');
end;

{ TXMLStreamForTest }

class function TXMLStreamForTest.New: IDataStream;
begin
  Result := TDataStream.New(
      '<?xml version="1.0" encoding="UTF-8"?>'
      + '<root>'
      + '  <group>'
      + '    <item>'
      + '      <name>foo</name>'
      + '      <value>bar</value>'
      + '    </item>'
      + '    <item>'
      + '      <name>foo2</name>'
      + '      <value>bar2</value>'
      + '    </item>'
      + '  </group>'
      + '</root>'
  );
end;

{ TXMLPackTest }

procedure TXMLPackTest.Load;
begin
  TXMLPack.New(TXMLFileForTest.New.Stream)
end;

procedure TXMLPackTest.XPath;
begin
  CheckNotNull(
    TXMLPack.New(TXMLFileForTest.New.Stream).XPath(
      '/CONFIG/Package/CompilerOptions'
    )
  );
end;

{ TXMLNodeTest }

procedure TXMLNodeTest.Name;
begin
  CheckEquals(
    UnicodeString('CompilerOptions'),
    TXMLPack.New(TXMLFileForTest.New.Stream).XPath(
      '/CONFIG/Package/CompilerOptions'
    ).Name
  );
end;

procedure TXMLNodeTest.Value;
begin
  CheckEquals(
    UnicodeString('foo'),
    TXMLPack.New(TXMLStreamForTest.New).XPath(
      '/root/group/item/name'
    ).Value
  );
end;

procedure TXMLNodeTest.Attrs;
begin
  CheckEquals(
    1,
    TXMLPack.New(TXMLFileForTest.New.Stream).XPath(
      '/CONFIG/Package/CompilerOptions/Version'
    ).Attrs.Count
  );
end;

procedure TXMLNodeTest.Childs;
begin
  CheckEquals(
    2,
    TXMLPack.New(TXMLStreamForTest.New).XPath(
      '/root/group'
    ).Childs.Count
  );
end;

procedure TXMLNodeTest.Up;
begin
  CheckEquals(
    UnicodeString('Package'),
    TXMLPack.New(TXMLFileForTest.New.Stream).XPath(
      '/CONFIG/Package/CompilerOptions'
    ).Up.Name
  );
end;

{ TXMLAttributeTest }

procedure TXMLAttributeTest.Name;
begin
  CheckEquals(
    UnicodeString('Value'),
    TXMLPack.New(TXMLFileForTest.New.Stream).XPath(
      '/CONFIG/Package/Name'
    ).Attrs.Item(0).Name
  );
end;

procedure TXMLAttributeTest.Value;
begin
  CheckEquals(
    UnicodeString('xavier'),
    TXMLPack.New(TXMLFileForTest.New.Stream).XPath(
      '/CONFIG/Package/Name'
    ).Attrs.Item(0).Value
  );
end;

initialization
  TTestSuite.New('Core')
    .Add(TTest.New(TXMLPackTest))
    .Add(TTest.New(TXMLNodeTest))
    .Add(TTest.New(TXMLAttributeTest))

end.


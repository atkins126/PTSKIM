unit TestGentile;

////////////////////////////////////////////////////////////////////////////////
//
// Author: Jaap Baak
// https://github.com/transportmodelling/PTSKIM
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
interface
////////////////////////////////////////////////////////////////////////////////

uses
  DUnitX.TestFramework,LineChoi,LineChoi.Gentile;

type
  [TestFixture]
  TGentilLineChoiTest = class(TObject)
  private
    LineChoiceOptions: TLineChoiceOptionsList;
    LineChoiceModel: TGentileLineChoiceModel;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestArticleExample;
    [Test]
    procedure TestTransitAndWalkOptions;
    [Test]
    procedure Test2WalkOptions;
  end;

////////////////////////////////////////////////////////////////////////////////
implementation
////////////////////////////////////////////////////////////////////////////////

procedure TGentilLineChoiTest.Setup;
begin
  LineChoiceOptions := TLineChoiceOptionsList.Create;
  LineChoiceModel := TGentileLineChoiceModel.Create;
end;

procedure TGentilLineChoiTest.TearDown;
begin
  LineChoiceOptions.Free;
  LineChoiceModel.Free;
end;

procedure TGentilLineChoiTest.TestArticleExample;
// Test based on section 5.1 (Numerical examples) of the article by Gentile et al.
// Line choice results are compared to the results reported in table 2, for the
// case deterministic headways (m=infinite).
Var
  WaitTime: Float64;
  LineProbabilities: array of Float64;
begin
  SetLength(LineProbabilities,3);
  LineChoiceOptions.Clear;
  LineChoiceOptions.AddOption(20,30);
  LineChoiceOptions.AddOption(15,40);
  LineChoiceOptions.AddOption(10,45);
  LineChoiceModel.LineChoice(LineChoiceOptions,LineProbabilities,WaitTime);
  Assert.AreEqual(7.27,WaitTime,5E-3);
  Assert.AreEqual(0.805,LineProbabilities[0],6E-4);
  Assert.AreEqual(0.160,LineProbabilities[1],5E-4);
  Assert.AreEqual(0.035,LineProbabilities[2],5E-4);
end;

procedure TGentilLineChoiTest.TestTransitAndWalkOptions;
// Line choice between a transit option with a travel time of 6 minutes and a headway of
// 12 minutes, and a walk option with travel time 10 minutes (and headway 0).
// The transit option will be faster when the waiting time for the vehicle is less
// than 4 minutes. The chance the waiting time will be less than 4 minutes equals 4/12 = 1/3.
// On average the waiting time for the transit option will be half the maximum waiting
// time of 4 minutes, so 2 minutes. For the walk option the waiting time will be zero,
// so the total expected waiting time equals 1/3*2 + 2/3*0 = 2/3 minutes.
Var
  WaitTime: Float64;
  LineProbabilities: array of Float64;
begin
  SetLength(LineProbabilities,2);
  LineChoiceOptions.Clear;
  LineChoiceOptions.AddOption(0,10);
  LineChoiceOptions.AddOption(12,6);
  LineChoiceModel.LineChoice(LineChoiceOptions,LineProbabilities,WaitTime);
  Assert.AreEqual(2/3,WaitTime,5E-6);
  Assert.AreEqual(2/3,LineProbabilities[0],5E-6);
  Assert.AreEqual(1/3,LineProbabilities[1],5E-6);
end;

procedure TGentilLineChoiTest.Test2WalkOptions;
// Choice between 2 walk options. As both options have zero headway,
// the fastest walk option will have a 100% share.
Var
  WaitTime: Float64;
  LineProbabilities: array of Float64;
begin
  SetLength(LineProbabilities,2);
  LineChoiceOptions.Clear;
  LineChoiceOptions.AddOption(0,10);
  LineChoiceOptions.AddOption(0,6);
  LineChoiceModel.LineChoice(LineChoiceOptions,LineProbabilities,WaitTime);
  Assert.AreEqual(0.0,WaitTime,5E-6);
  Assert.AreEqual(0.0,LineProbabilities[0],5E-6);
  Assert.AreEqual(1.0,LineProbabilities[1],5E-6);
end;

initialization
  TDUnitX.RegisterTestFixture(TGentilLineChoiTest);
end.
unit UserClass;

////////////////////////////////////////////////////////////////////////////////
//
// Author: Jaap Baak
// https://github.com/transportmodelling/PTSKIM
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
interface
////////////////////////////////////////////////////////////////////////////////

Uses
  Crowding;

Type
  TUserClass = record
  public
    UserClass: Integer;
    CrowdingModel: TCrowdingModel;
    BoardingPenalty,ValueOfTime: Float64;
    Class Operator Finalize(var UserClass: TUserClass);
  end;

////////////////////////////////////////////////////////////////////////////////
implementation
////////////////////////////////////////////////////////////////////////////////

Class Operator TUserClass.Finalize(var UserClass: TUserClass);
begin
  UserClass.CrowdingModel.Free;
end;

end.
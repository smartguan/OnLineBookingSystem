function translateErrCode(data) {
	var message = null;
	switch (data) {
	case 101:
		message = "FIRST_NOT_VALID";
		break;
	case 102:
		message = "LAST_NOT_VALID";
		break;
	case 103:
		message = "EMAIL_NOT_VALID";
		break;
	case 104:
		message = "PASS_NOT_VALID";
		break;
	case 105:
		message = "DOB_NOT_VALID";
		break;
	case 106:
		message = "ZIP_NOT_VALID";
		break;
	case 107:
		message = "USER_EXISTS";
		break;
	case 108:
		message = "BAD_CREDENTIALS";
		break;
	case 109:
		message = "PASS_NOT_MATCH";
		break;
	case 200:
		message = "SEC_NAME_INVALID";
		break;
	case 201:
		message = "DAY_INVALID";
		break;
	case 202:
		message = "DESCR_INVALID";
		break;
	case 203:
		message = "TEACHER_INVALID";
		break;
	case 204:
		message = "SEC_OVERLAP_FOR_TEACHER";
		break;
	case 205:
		message = "TIME_INVALID";
		break;
	case 206:
		message = "DATE_INVALID";
		break;
	case 207:
		message = "SECTYPE_DATE_NOT_MATCH";
		break;
	case 208:
		message = "FAILDED_TO_DELETE";
		break;
	case 300:
		message = "NO_SECTION_TO_SHOW";
		break;
	case 301:
		message = "FAILED_TO_MAKE_REG";
		break;
	case 302:
		message = "PASS_DROP_DEADLINE";
		break;
	case 303:
		message = "USER_NOT_REG";
		break;
	case 1:
		message = "";
		break;
	default:
		message = "UNKNOWN_ERROR";
		break;
	}

	return message;
}

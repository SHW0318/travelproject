<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>:: JavaScript 캘린더 ::</title>
    <style type="text/css">
        a { color:#000000;text-decoration:none; }
        .scriptCalendar { text-align:center; }
        .scriptCalendar > thead > tr > td { width:50px;height:50px; }
        .scriptCalendar > thead > tr:first-child > td { font-weight:bold; }
        .scriptCalendar > thead > tr:last-child > td { background-color:#90EE90; }
        .scriptCalendar > tbody > tr > td { width:50px;height:50px; }
        .calendarBtn { cursor:pointer; }
    </style>
    <form id="calendarForm" action="/processCalendar" method="POST">
    <input type="hidden" id="selectedDate" name="selectedDate">
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function() {
            buildCalendar();

            document.getElementById("btnPrevCalendar").addEventListener("click", function(event) {
                prevCalendar();
            });

            document.getElementById("nextNextCalendar").addEventListener("click", function(event) {
                nextCalendar();
            });
        });

        var toDay = new Date(); // @param 전역 변수, 오늘 날짜 / 내 컴퓨터 로컬을 기준으로 toDay에 Date 객체를 넣어줌
        var nowDate = new Date();  // @param 전역 변수, 실제 오늘날짜 고정값
        var selectedDates = [];

        /**
         * @brief   이전달 버튼 클릭시
         */
        function prevCalendar() {
            this.toDay = new Date(toDay.getFullYear(), toDay.getMonth() - 1, toDay.getDate());
            buildCalendar();    // @param 전월 캘린더 출력 요청
        }

        /**
         * @brief   다음달 버튼 클릭시
         */
        function nextCalendar() {
            this.toDay = new Date(toDay.getFullYear(), toDay.getMonth() + 1, toDay.getDate());
            buildCalendar();    // @param 명월 캘린더 출력 요청
        }

        /**
         * @brief   캘린더 오픈
         * @details 날짜 값을 받아 캘린더 폼을 생성하고, 날짜값을 채워넣는다.
         */
        function buildCalendar() {

            var doMonth = new Date(toDay.getFullYear(), toDay.getMonth(), 1);
            var lastDate = new Date(toDay.getFullYear(), toDay.getMonth() + 1, 0);

            var tbCalendar = document.querySelector(".scriptCalendar > tbody");

            document.getElementById("calYear").innerText = toDay.getFullYear();                       // @param YYYY월
            document.getElementById("calMonth").innerText = autoLeftPad((toDay.getMonth() + 1), 2);   // @param MM월


            // @details 이전 캘린더의 출력결과가 남아있다면, 이전 캘린더를 삭제한다.
            while(tbCalendar.rows.length > 0) {
                tbCalendar.deleteRow(tbCalendar.rows.length - 1);
            }

            // @param 첫번째 개행
            var row = tbCalendar.insertRow();

            // @param 날짜가 표기될 열의 증가값
            var dom = 1;

            // @details 시작일의 요일값( doMonth.getDay() ) + 해당월의 전체일( lastDate.getDate())을  더해준 값에서
            //               7로 나눈값을 올림( Math.ceil() )하고 다시 시작일의 요일값( doMonth.getDay() )을 빼준다.
            var daysLength = (Math.ceil((doMonth.getDay() + lastDate.getDate()) / 7) * 7) - doMonth.getDay();

            // @param 달력 출력
            // @details 시작값은 1일을 직접 지정하고 요일값( doMonth.getDay() )를 빼서 마이너스( - )로 for문을 시작한다.
            for(var day = 1 - doMonth.getDay(); daysLength >= day; day++) {

                var column = row.insertCell();

                // @param 평일( 전월일과 익월일의 데이터 제외 )
                if(Math.sign(day) == 1 && lastDate.getDate() >= day) {

                    // @param 평일 날짜 데이터 삽입
                    column.innerText = autoLeftPad(day, 2);

                    // @param 일요일인 경우
                    if(dom % 7 == 1) {
                        column.style.color = "#FF4D4D";
                    }

                    // @param 토요일인 경우
                    if(dom % 7 == 0) {
                        column.style.color = "#4D4DFF";
                        row = tbCalendar.insertRow();   // @param 토요일이 지나면 다시 가로 행을 한줄 추가한다.
                    }

                }

                // @param 평일 전월일과 익월일의 데이터 날짜변경
                else {
                    var exceptDay = new Date(doMonth.getFullYear(), doMonth.getMonth(), day);
                    column.innerText = autoLeftPad(exceptDay.getDate(), 2);
                    column.style.color = "#A9A9A9";
                }

                // @brief   전월, 명월 음영처리
                // @details 현재년과 선택 년도가 같은경우
                if(toDay.getFullYear() == nowDate.getFullYear()) {

                    // @details 현재월과 선택월이 같은경우
                    if(toDay.getMonth() == nowDate.getMonth()) {

                        // @details 현재일보다 이전인 경우이면서 현재월에 포함되는 일인경우
                        if(nowDate.getDate() > day && Math.sign(day) == 1) {
                            column.style.backgroundColor = "#E5E5E5";
                        }

                        // @details 현재일보다 이후이면서 현재월에 포함되는 일인경우
                        else if(nowDate.getDate() < day && lastDate.getDate() >= day) {
                            column.style.backgroundColor = "#FFFFFF";
                            column.style.cursor = "pointer";
                            column.onclick = function(){ calendarChoiceDay(this); };
                        }

                        // @details 현재일인 경우
                        else if(nowDate.getDate() == day) {
                            column.style.backgroundColor = "#FFFFE6";
                            column.style.cursor = "pointer";
                            column.onclick = function(){ calendarChoiceDay(this); };
                        }

                    // @details 현재월보다 이전인경우
                    } else if(toDay.getMonth() < nowDate.getMonth()) {
                        if(Math.sign(day) == 1 && day <= lastDate.getDate()) {
                            column.style.backgroundColor = "#E5E5E5";
                        }
                    }

                    // @details 현재월보다 이후인경우
                    else {
                        if(Math.sign(day) == 1 && day <= lastDate.getDate()) {
                            column.style.backgroundColor = "#FFFFFF";
                            column.style.cursor = "pointer";
                            column.onclick = function(){ calendarChoiceDay(this); };
                        }
                    }
                }

                // @details 선택한년도가 현재년도보다 작은경우
                else if(toDay.getFullYear() < nowDate.getFullYear()) {
                    if(Math.sign(day) == 1 && day <= lastDate.getDate()) {
                        column.style.backgroundColor = "#E5E5E5";
                    }
                }

                // @details 선택한년도가 현재년도보다 큰경우
                else {
                    if(Math.sign(day) == 1 && day <= lastDate.getDate()) {
                        column.style.backgroundColor = "#FFFFFF";
                        column.style.cursor = "pointer";
                        column.onclick = function(){ calendarChoiceDay(this); };
                    }
                }
                dom++;
            }
        }

        /**
         * @brief   날짜 선택
         * @details 사용자가 선택한 날짜에 체크표시를 남긴다.
         */
        function calendarChoiceDay(column) {

            // @param 기존 선택일이 존재하는 경우 기존 선택일의 표시형식을 초기화 한다.
            if(document.getElementsByClassName("choiceDay")[0]) {
                
                // @see 금일인 경우
                if(document.getElementById("calMonth").innerText == autoLeftPad((nowDate.getMonth() + 1), 2) && document.getElementsByClassName("choiceDay")[0].innerText == autoLeftPad(toDay.getDate(), 2)) {
                    document.getElementsByClassName("choiceDay")[0].style.backgroundColor = "#FFFFE6";  
                }
                
                // @see 금일이 아닌 경우
                else {
                    document.getElementsByClassName("choiceDay")[0].style.backgroundColor = "#FFFFFF";
                }
                document.getElementsByClassName("choiceDay")[0].classList.remove("choiceDay");
            }

            // @param 선택일 체크 표시
            column.style.backgroundColor = "#FF9999";

            // @param 선택일 클래스명 변경
            column.classList.add("choiceDay");
        }

        /**
         * @brief   숫자 두자릿수( 00 ) 변경
         * @details 자릿수가 한자리인 ( 1, 2, 3등 )의 값을 10, 11, 12등과 같은 두자리수 형식으로 맞추기위해 0을 붙인다.
         * @param   num     앞에 0을 붙일 숫자 값
         * @param   digit   글자의 자릿수를 지정 ( 2자릿수인 경우 00, 3자릿수인 경우 000 … )
         */
        function autoLeftPad(num, digit) {
            if(String(num).length < digit) {
                num = new Array(digit - String(num).length + 1).join("0") + num;
            }
            return num;
        }
    </script>
</head>
<body>
    <table border="1" cellspacing="0" cellpadding="0" class="scriptCalendar">
        <thead>
            <tr>
                <td colspan="7">
                    <input type="button" value="◀" id="btnPrevCalendar" class="calendarBtn" />
                    <span id="calYear"></span>년&nbsp;
                    <span id="calMonth"></span>월
                    <input type="button" value="▶" id="nextNextCalendar" class="calendarBtn" />
                </td>
            </tr>
            <tr>
                <td>일</td>
                <td>월</td>
                <td>화</td>
                <td>수</td>
                <td>목</td>
                <td>금</td>
                <td>토</td>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    </form>
</body>
</html>
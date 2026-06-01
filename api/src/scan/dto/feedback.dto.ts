import { IsIn, IsNotEmpty, IsString } from "class-validator";

// Feedback dto berfungsi ketika user setelah mendapatkan hasil diagnosis 
// memberikan feedback apakah hasil diagnosis akurat atau tidak
// jika feedback tidak akurat maka harus mempertajam prompt di gemini service
export class FeedbackDto {
    @IsString()
    @IsNotEmpty()
    @IsIn(['accurate', 'inaccurate'])
    feedback: string;
}    
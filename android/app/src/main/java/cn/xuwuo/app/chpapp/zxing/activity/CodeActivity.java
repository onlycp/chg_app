package cn.xuwuo.app.chpapp.zxing.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.view.Window;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import cn.xuwuo.app.chpapp.R;

public class CodeActivity extends Activity implements View.OnClickListener {

    private EditText code_number;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_code);
        initUI();
    }

    private void initUI(){
        ImageView back = findViewById(R.id.back);
        back.setOnClickListener(this);

        code_number = findViewById(R.id.code_number);

        TextView ok_tv = findViewById(R.id.ok_tv);
        ok_tv.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.back:
                finish();
                break;
            case R.id.ok_tv:
                if (code_number.getText().length() > 0) {
                    Intent intent = new Intent();
                    intent.putExtra("REQUEST_CODE_NUMBER", code_number.getText().toString());
                    setResult(Activity.RESULT_OK, intent);
                    finish();
                }
                break;
        }
    }
}
